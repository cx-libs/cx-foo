  // Project: AutoSDK
  // Company: NavInfo Co.,Ltd.
  // All rights reserved
  // (c) Copyright 2022

#include "hdmap/datacontrol/datasource/cmd/BaseCmd.h"
#include "hdmap/datacontrol/datasource/queue/BaseQueue.h"
#include "common/utils/threadhelper.hpp"
#include "common/log/log.hpp"

namespace navinfo {
namespace projects {
namespace hdmap {
namespace datacontrol {
namespace datasource {

CBaseQueue::CBaseQueue(const char *pThreadName)
  : m_mutex_(), m_cv_(), m_spthread_(),
  m_str_threadname_(pThreadName),
  m_bexit_(false) {
}

CBaseQueue::~CBaseQueue() {
}

ResuleCode CBaseQueue::Init() {
  std::unique_lock<std::mutex> lock(m_mutex_);

  m_cmdlist_.clear();
  m_spthread_ = std::shared_ptr<std::thread>(new std::thread([this] { Run(); }));
  navinfo::projects::common::SetCurrentThreadName(m_str_threadname_.c_str());
  return RC_SUCCESS;
}

ResuleCode CBaseQueue::UnInit() {
  m_bexit_ = true;
  m_cv_.notify_one();

  if (m_spthread_->joinable()) {
    m_spthread_->join(); {
      std::unique_lock<std::mutex> lock(m_mutex_);
      m_cmdlist_.clear();
    }
  }

  return RC_SUCCESS;
}

ResuleCode CBaseQueue::AddCmd(const std::shared_ptr<CBaseCmd> &spcmd) {
  std::unique_lock<std::mutex> lock(m_mutex_);

  m_cmdlist_.push_back(spcmd);
  m_cv_.notify_one();

  return RC_SUCCESS;
}

ResuleCode CBaseQueue::DealWithCmd(const std::shared_ptr<CBaseCmd> &spcmd) {
  if (spcmd == nullptr) {
    LOG_ERROR << "[DC]Spcmd is Null!";
    return RC_FAILURE;
  }
  CHECK_RESULT_CODE_RET_RESULT_CODE(spcmd->DealWithCmd());

  return RC_SUCCESS;
}

int CBaseQueue::Run() {
  int ret = RC_SUCCESS;

  while (!m_bexit_) {
    std::shared_ptr<CBaseCmd> spcmd; {
      std::unique_lock<std::mutex> lock(m_mutex_);

      if (!m_cmdlist_.empty()) {
        spcmd = m_cmdlist_.front();
        m_cmdlist_.pop_front();
      } else {
        m_cv_.wait(lock);
        continue;
      }

      CHECK_RESULT_CODE_RET_NONE(DealWithCmd(spcmd));
    }
  }
  LOG_DEBUG("Run [%s] end", m_str_threadname_.c_str());
  return ret;
}

}  // namespace datasource
}  // namespace datacontrol
}  // namespace hdmap
}  // namespace projects
}  // namespace navinfo
