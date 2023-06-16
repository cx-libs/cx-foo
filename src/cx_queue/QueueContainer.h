  // Project: AutoSDK
  // Company: NavInfo Co.,Ltd.
  // All rights reserved
  // (c) Copyright 2022

#ifndef HDMAP_DATACONTROL_DATASOURCE_QUEUE_QUEUECONTAINER_H_
#define HDMAP_DATACONTROL_DATASOURCE_QUEUE_QUEUECONTAINER_H_

#include <mutex>
#include <memory>
#include <map>
#include "hdmap/datacontrol/datasource/queue/BaseQueue.h"

namespace navinfo {
namespace projects {
namespace hdmap {
namespace datacontrol {
namespace datasource {

class CBaseQueue;

/**
 * @brief queue容器
 * 
 */
class CQueueContainer {
 public:
  /**
   * @brief Construct a new CQueueContainer object
   * 
   */
  CQueueContainer();
  /**
   * @brief Destroy the CQueueContainer object
   * 
   */
  ~CQueueContainer();

  /**
   * @brief 初始化
   * 
   * @return RESULT_CODE 返回码
   */
  ResuleCode Init();
  /**
   * @brief 不初始化
   * 
   * @return RESULT_CODE 返回码
   */
  ResuleCode UnInit();
  /**
   * @brief Get the Queue object
   * 
   * @param[in] ulType queue中类型
   * @param[out] spqueue queue共享指针
   * @return RESULT_CODE 返回码
   */
  ResuleCode get_queue(uint16_t ulType, std::shared_ptr<CBaseQueue> &spqueue);

 private:
  /**
   * @brief 锁
   * 
   */
  std::mutex m_mutex_;
  /**
   * @brief queue map
   * 
   */
  std::map<uint16_t, std::shared_ptr<CBaseQueue>> m_mapqueues_;
};

}  // namespace datasource
}  // namespace datacontrol
}  // namespace hdmap
}  // namespace projects
}  // namespace navinfo
#endif  // HDMAP_DATACONTROL_DATASOURCE_QUEUE_QUEUECONTAINER_H_
