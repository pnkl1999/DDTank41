using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Center.Server
{
    public class ServerMgr
    {
        private static Dictionary<int, ServerInfo> _list = new Dictionary<int, ServerInfo>();

        private static object _syncStop = new object();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static ServerInfo[] Servers=> _list.Values.ToArray();

        public static ServerInfo GetServerInfo(int id)
        {
			if (_list.ContainsKey(id))
			{
				return _list[id];
			}
			return null;
        }

        public static int GetState(int count, int total)
        {
			if (count >= total)
			{
				return 5;
			}
			if ((double)count > (double)total * 0.5)
			{
				return 4;
			}
			return 2;
        }

        public static bool ReLoadServerList()
        {
			try
			{
				using (ServiceBussiness bussiness = new ServiceBussiness())
				{
					lock (_syncStop)
					{
						ServerInfo[] serverList = bussiness.GetServerList();
						ServerInfo[] array = serverList;
						foreach (ServerInfo info in array)
						{
							if (_list.ContainsKey(info.ID))
							{
								_list[info.ID].IP = info.IP;
								_list[info.ID].Name = info.Name;
								_list[info.ID].Port = info.Port;
								_list[info.ID].Room = info.Room;
								_list[info.ID].Total = info.Total;
								_list[info.ID].MustLevel = info.MustLevel;
								_list[info.ID].LowestLevel = info.LowestLevel;
								_list[info.ID].Online = info.Online;
								_list[info.ID].State = info.State;
							}
							else
							{
								info.State = 1;
								info.Online = 0;
								_list.Add(info.ID, info);
							}
						}
					}
				}
				log.Info("ReLoad server list from db.");
				return true;
			}
			catch (Exception exception)
			{
				log.ErrorFormat("ReLoad server list from db failed:{0}", exception);
				return false;
			}
        }

        public static void SaveToDatabase()
        {
			try
			{
				using ServiceBussiness bussiness = new ServiceBussiness();
				foreach (ServerInfo info in _list.Values)
				{
					bussiness.UpdateService(info);
				}
			}
			catch (Exception exception)
			{
				log.Error("Save server state", exception);
			}
        }

        public static bool Start()
        {
			try
			{
				using (ServiceBussiness bussiness = new ServiceBussiness())
				{
					ServerInfo[] serverList = bussiness.GetServerList();
					ServerInfo[] array = serverList;
					foreach (ServerInfo info in array)
					{
						info.State = 1;
						info.Online = 0;
						_list.Add(info.ID, info);
					}
				}
				log.Info("Load server list from db.");
				return true;
			}
			catch (Exception exception)
			{
				log.ErrorFormat("Load server list from db failed:{0}", exception);
				return false;
			}
        }
    }
}
