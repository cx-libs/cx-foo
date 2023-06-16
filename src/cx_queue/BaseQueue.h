  // Project: AutoSDK
  // Company: NavInfo Co.,Ltd.
  // All rights reserved
  // (c) Copyright 2022

#ifndef HDMAP_DATACONTROL_DATASOURCE_QUEUE_BASEQUEUE_H_
#define HDMAP_DATACONTROL_DATASOURCE_QUEUE_BASEQUEUE_H_

#include <string>
#include <list>
#include <memory>
#include <atomic>
#include <thread>              // std::thread
#include <mutex>               // std::mutex, std::unique_lock
#include <condition_variable>  // std::condition_variable

namespace navinfo {
namespace projects {
namespace hdmap {
namespace datacontrol {
namespace datasource {

class CBaseCmd;
/**
 * @brief Queue基类
 * 
 */
class CBaseQueue {
 public:
	/**
	 * @brief Construct a new CBaseQueue object
	 * 
	 * @param[in] pthreadname 线程名
	 */
	explicit CBaseQueue(const char *pthreadname);
	/**
	 * @brief Destroy the CBaseQueue object
	 * 
	 */
	virtual ~CBaseQueue();

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
	 * @brief 增加控制
	 * 
	 * @param[in] spcmd 控制命令
	 * @return RESULT_CODE 返回码
	 */
  ResuleCode AddCmd(const std::shared_ptr<CBaseCmd> &spcmd);

 protected:
	/**
	 * @brief 控制处理
	 * 
	 * @param[in] spcmd 控制命令
	 * @return RESULT_CODE 返回码
	 */
   ResuleCode DealWithCmd(const std::shared_ptr<CBaseCmd> &spcmd);
	/**
	 * @brief 线程运行
	 * 
	 * @return int 
	 */
	int Run();


 private:
	/**
	 * @brief QUEUE事件枚举值
	 * 
	 */
	enum {
		QUEUE_EVENT_UPDATE_BIT,
		QUEUE_EVENT_EXIT_BIT,
	};

	/**
	 * @brief queue更新标志位
	 * 
	 */
	static const uint16_t qe_update_flag = (1 << QUEUE_EVENT_UPDATE_BIT);
	/**
	 * @brief queue退出标志位
	 * 
	 */
	static const uint16_t qe_exit_flag = (1 << QUEUE_EVENT_EXIT_BIT);

 private:
	/**
	 * @brief 锁
	 * 
	 */
	std::mutex m_mutex_;
	/**
	 * @brief 环境变量
	 * 
	 */
	std::condition_variable m_cv_;
	/**
	 * @brief 线程共享指针
	 * 
	 */
	std::shared_ptr<std::thread> m_spthread_;

	/**
	 * @brief 命令列表
	 * 
	 */
	std::list<std::shared_ptr<CBaseCmd>>	m_cmdlist_;
	/**
	 * @brief 线程名称
	 * 
	 */
	std::string m_str_threadname_;
	/**
	 * @brief 退出
	 * 
	 */
	std::atomic<bool> m_bexit_;
};

}  // namespace datasource
}  // namespace datacontrol
}  // namespace hdmap
}  // namespace projects
}  // namespace navinfo
#endif  // HDMAP_DATACONTROL_DATASOURCE_QUEUE_BASEQUEUE_H_
