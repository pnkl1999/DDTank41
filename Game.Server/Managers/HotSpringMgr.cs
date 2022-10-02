using Bussiness;
using Game.Base.Packets;
using Game.Server.HotSpringRooms;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;

namespace Game.Server.Managers
{
    public class HotSpringMgr
    {
        protected static TankHotSpringLogicProcessor _processor = new TankHotSpringLogicProcessor();

        private static Dictionary<int, HotSpringRoom> dictionary_0;

        public static string[] HotSpringEnterPriRoom;

        private static readonly ILog ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected static ReaderWriterLock m_lock;

        protected static ThreadSafeRandom m_rand;

        private static string[] string_0;

        public static HotSpringRoom CreateHotSpringRoomFromDB(HotSpringRoomInfo roomInfo)
        {
			HotSpringRoom hotSpringRoom = null;
			m_lock.AcquireWriterLock(-1);
			try
			{
				hotSpringRoom = new HotSpringRoom(roomInfo, _processor);
				if (hotSpringRoom != null)
				{
					dictionary_0.Add(hotSpringRoom.Info.roomID, hotSpringRoom);
					return hotSpringRoom;
				}
			}
			finally
			{
				m_lock.ReleaseWriterLock();
			}
			return null;
        }

        public static HotSpringRoom[] GetAllHotSpringRoom()
        {
			HotSpringRoom[] array = null;
			m_lock.AcquireReaderLock(-1);
			try
			{
				array = new HotSpringRoom[dictionary_0.Count];
				dictionary_0.Values.CopyTo(array, 0);
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
			if (array != null)
			{
				return array;
			}
			return new HotSpringRoom[0];
        }

        public static int GetExpWithLevel(int grade)
        {
			try
			{
				if (grade <= string_0.Length)
				{
					return int.Parse(string_0[grade - 1]);
				}
			}
			catch (Exception ex)
			{
				ilog_0.Error("GetExpWithLevel Error: " + ex.ToString());
			}
			return 0;
        }

        public static HotSpringRoom GetHotSpringRoombyID(int id)
        {
			HotSpringRoom result = null;
			m_lock.AcquireReaderLock(-1);
			try
			{
				if (id > 0)
				{
					if (dictionary_0.Keys.Contains(id))
					{
						return dictionary_0[id];
					}
					return result;
				}
				return result;
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        public static HotSpringRoom GetHotSpringRoombyID(int id, string pwd, ref string msg)
        {
			HotSpringRoom result = null;
			m_lock.AcquireReaderLock(-1);
			try
			{
				if (id <= 0 || !dictionary_0.Keys.Contains(id))
				{
					return result;
				}
				if (dictionary_0[id].Info.roomPassword != pwd)
				{
					msg = "A senha está incorreta!";
					return result;
				}
				return dictionary_0[id];
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        public static HotSpringRoom GetRandomRoom()
        {
			HotSpringRoom result = null;
			m_lock.AcquireReaderLock(-1);
			try
			{
				List<HotSpringRoom> list = new List<HotSpringRoom>();
				foreach (HotSpringRoom value in dictionary_0.Values)
				{
					if (value.Count < value.Info.maxCount)
					{
						list.Add(value);
					}
				}
				if (list.Count > 0)
				{
					int index = m_rand.Next(0, 4);
					return list[index];
				}
				return result;
			}
			finally
			{
				m_lock.ReleaseReaderLock();
			}
        }

        public static bool Init()
        {
			//
			try
			{
				m_lock = new ReaderWriterLock();
				m_rand = new ThreadSafeRandom();
				dictionary_0 = new Dictionary<int, HotSpringRoom>();
				char[] separator = new char[1]
				{
					','
				};
				//string EXPSTR = "200,240,288,346,415,498,597,717,860,946,1041,1145,1259,1385,1523,1676,1843,2028,2231,2342,2459,2582,2711,2847,2989,3139,3295,3460,3633,3815,3929,4047,4169,4294,4423,4555,4692,4833,4978,5127,5281,5439,5602,5770,5944,6122,6306,6495,6690,6890,7097,7310,7529,7755,7988,8227,8474,8728,8990,9260,9530,9800,10070,10340,10610,10880,11150,11420,11690,11960";
				string_0 = GameProperties.HotSpringExp.Split(separator);
				//Console.WriteLine(GameProperties.HotSpringExp);
				char[] separator2 = new char[1]
				{
					','
				};
				HotSpringEnterPriRoom = GameProperties.SpaPubRoomLoginPay.Split(separator2);
				smethod_0();
				return true;
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("HotSpringMgr", exception);
				}
				return false;
			}
        }

        public static void SendUpdateAllRoom(GamePlayer p, HotSpringRoom[] rooms)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(197);
			gSPacketIn.WriteInt(rooms.Length);
			foreach (HotSpringRoom hotSpringRoom in rooms)
			{
				gSPacketIn.WriteInt(hotSpringRoom.Info.roomNumber);
				gSPacketIn.WriteInt(hotSpringRoom.Info.roomID);
				gSPacketIn.WriteString(hotSpringRoom.Info.roomName);
				gSPacketIn.WriteString((hotSpringRoom.Info.roomPassword != null) ? "password" : "");
				gSPacketIn.WriteInt(hotSpringRoom.Info.effectiveTime);
				gSPacketIn.WriteInt(hotSpringRoom.Count);
				gSPacketIn.WriteInt(hotSpringRoom.Info.playerID);
				gSPacketIn.WriteString(hotSpringRoom.Info.playerName);
				gSPacketIn.WriteDateTime(hotSpringRoom.Info.startTime);
				gSPacketIn.WriteString(hotSpringRoom.Info.roomIntroduction);
				gSPacketIn.WriteInt(hotSpringRoom.Info.roomType);
				gSPacketIn.WriteInt(hotSpringRoom.Info.maxCount);
			}
			if (p != null)
			{
				p.SendTCP(gSPacketIn);
			}
			else
			{
				WorldMgr.HotSpringScene.SendToALL(gSPacketIn);
			}
        }

        private static void smethod_0()
        {
			using ProduceBussiness produceBussiness = new ProduceBussiness();
			HotSpringRoomInfo[] allHotSpringRooms = produceBussiness.GetAllHotSpringRooms();
			for (int i = 0; i < allHotSpringRooms.Length; i++)
			{
				CreateHotSpringRoomFromDB(allHotSpringRooms[i]);
			}
        }
    }
}
