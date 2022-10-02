using Game.Base.Packets;
using Game.Logic;
using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using System.Timers;

namespace Game.Server.Managers
{
    public class MacroDropMgr
    {
        protected static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected static ReaderWriterLock m_lock = new ReaderWriterLock();

        public static bool Init()
        {
			m_lock = new ReaderWriterLock();
			return ReLoad();
        }

        private static void OnTimeEvent(object source, ElapsedEventArgs e)
        {
			Dictionary<int, int> dictionary = new Dictionary<int, int>();
			m_lock.AcquireWriterLock(-1);
			try
			{
				foreach (KeyValuePair<int, MacroDropInfo> item in DropInfoMgr.DropInfo)
				{
					int key = item.Key;
					MacroDropInfo value = item.Value;
					if (value.SelfDropCount > 0)
					{
						dictionary.Add(key, value.SelfDropCount);
						value.SelfDropCount = 0;
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("DropInfoMgr OnTimeEvent", exception);
				}
			}
			finally
			{
				m_lock.ReleaseWriterLock();
			}
			if (dictionary.Count <= 0)
			{
				return;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(178);
			gSPacketIn.WriteInt(dictionary.Count);
			foreach (KeyValuePair<int, int> item2 in dictionary)
			{
				gSPacketIn.WriteInt(item2.Key);
				gSPacketIn.WriteInt(item2.Value);
			}
			GameServer.Instance.LoginServer.SendPacket(gSPacketIn);
        }

        public static bool ReLoad()
        {
			try
			{
				DropInfoMgr.DropInfo = new Dictionary<int, MacroDropInfo>();
				return true;
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("DropInfoMgr", exception);
				}
			}
			return false;
        }

        public static void Start()
        {
			System.Timers.Timer timer = new System.Timers.Timer();
			timer.Elapsed += OnTimeEvent;
			timer.Interval = 5000.0;
			timer.Enabled = true;
        }

        public static void UpdateDropInfo(Dictionary<int, MacroDropInfo> temp)
        {
			m_lock.AcquireWriterLock(-1);
			try
			{
				foreach (KeyValuePair<int, MacroDropInfo> item in temp)
				{
					if (DropInfoMgr.DropInfo.ContainsKey(item.Key))
					{
						DropInfoMgr.DropInfo[item.Key].DropCount = item.Value.DropCount;
						DropInfoMgr.DropInfo[item.Key].MaxDropCount = item.Value.MaxDropCount;
					}
					else
					{
						DropInfoMgr.DropInfo.Add(item.Key, item.Value);
					}
				}
			}
			catch (Exception exception)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("MacroDropMgr UpdateDropInfo", exception);
				}
			}
			finally
			{
				m_lock.ReleaseWriterLock();
			}
        }
    }
}
