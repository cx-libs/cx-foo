  // Project: AutoSDK
  // Company: NavInfo Co.,Ltd.
  // All rights reserved
  // (c) Copyright 2022

#include <sstream>
#include <string>

#include "hdmap/datacontrol/datasource/queue/BaseQueue.h"
#include "hdmap/datacontrol/datasource/queue/QueueContainer.h"
#include "common/log/log.hpp"

namespace navinfo {
namespace projects {
namespace hdmap {
namespace datacontrol {
namespace datasource {

const char* THREAD_NAME_QUEUE = "EHRQueue";

CQueueContainer::CQueueContainer() : m_mutex_(){
}

CQueueContainer::~CQueueContainer() {
}

ResuleCode CQueueContainer::Init() {
  std::unique_lock<std::mutex> lock(m_mutex_);

  std::stringstream ostr;
  ostr << THREAD_NAME_QUEUE << BQ_FROM_EHR_POSITION;

  std::shared_ptr<CBaseQueue> spqueuep = std::make_shared<CBaseQueue>(ostr.str().c_str());
  if (spqueuep == nullptr) {
    LOG_ERROR << "[DC][QueueContainer::Init]BQ_FROM_EHR_POSITION queue Create failed!";
    return RC_FAILURE;
  }
  if (RC_FAILURE == spqueuep->Init()) {
    LOG_ERROR << "[DC]BQ_FROM_EHR_POSITION queue Init failed!";
    return RC_FAILURE;
  }
  m_mapqueues_[BQ_FROM_EHR_POSITION] = spqueuep;

  ostr.str("");
  ostr << THREAD_NAME_QUEUE << BQ_FROM_EHR_SECTION;

  std::shared_ptr<CBaseQueue> spqueues = std::make_shared<CBaseQueue>(ostr.str().c_str());
  if (spqueues == nullptr) {
    LOG_ERROR << "[DC][QueueContainer::Init]BQ_FROM_EHR_SECTION queue Create failed!";
    return RC_FAILURE;
  }
  if (RC_FAILURE == spqueues->Init()) {
    LOG_ERROR << "[DC]BQ_FROM_EHR_SECTION queue Init failed!";
    return RC_FAILURE;
  }
  m_mapqueues_[BQ_FROM_EHR_SECTION] = spqueues;

  ostr.str("");
  ostr << THREAD_NAME_QUEUE << BQ_FROM_EHR_GEOFENCING;

  std::shared_ptr<CBaseQueue> spqueueg = std::make_shared<CBaseQueue>(ostr.str().c_str());
  if (spqueueg == nullptr) {
    LOG_ERROR << "[DC][QueueContainer::Init]BQ_FROM_EHR_GEOFENCING queue Create failed!";
    return RC_FAILURE;
  }
  if (RC_FAILURE == spqueueg->Init()) {
    LOG_ERROR << "[DC]BQ_FROM_EHR_GEOFENCING queue Init failed!";
    return RC_FAILURE;
  }

  m_mapqueues_[BQ_FROM_EHR_GEOFENCING] = spqueueg;


  return RC_SUCCESS;
}

ResuleCode CQueueContainer::UnInit() {
  // queue Uninit
  for (std::map<uint16_t, std::shared_ptr<CBaseQueue>>::iterator itr = m_mapqueues_.begin();
    itr != m_mapqueues_.end(); itr++) {
    if (itr->second == nullptr) {
      LOG_ERROR << "[DC]QueueContainer Uninit failed!";
      continue;
    }

    itr->second->UnInit();
  }

  std::unique_lock<std::mutex> lock(m_mutex_);
  m_mapqueues_.clear();

  return RC_SUCCESS;
}

ResuleCode CQueueContainer::get_queue(uint16_t ulType, std::shared_ptr<CBaseQueue> &spqueue) {
  std::unique_lock<std::mutex> lock(m_mutex_);

  ResuleCode ret = RC_FAILURE;
  std::map<uint16_t, std::shared_ptr<CBaseQueue>>::iterator itr = m_mapqueues_.find(ulType);
  if (itr != m_mapqueues_.end()) {
    spqueue = itr->second;
    ret = RC_SUCCESS;
  } else {
    LOG_ERROR << "[DC]get_queue failed! ulType:" << ulType;
  }

  return ret;
}

}  // namespace datasource
}  // namespace datacontrol
}  // namespace hdmap
}  // namespace projects
}  // namespace navinfo
