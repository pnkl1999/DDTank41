using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.GameRoom.Handle
{
    public class GameRoomHandleMgr
    {
        private Dictionary<int, IGameRoomCommandHadler> handles = new Dictionary<int, IGameRoomCommandHadler>();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public IGameRoomCommandHadler LoadCommandHandler(int code)
        {
			if (handles.ContainsKey(code))
			{
				return handles[code];
			}
			log.Error("LoadCommandHandler code009: " + code);
			return null;
        }

        public GameRoomHandleMgr()
        {
			handles.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }

        protected int SearchCommandHandlers(Assembly assembly)
        {
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.GameRoom.Handle.IGameRoomCommandHadler") == null))
				{
					GameRoomHandleAttbute[] array = (GameRoomHandleAttbute[])type.GetCustomAttributes(typeof(GameRoomHandleAttbute), inherit: true);
					if (array.Length != 0)
					{
						num++;
						RegisterCommandHandler(array[0].Code, Activator.CreateInstance(type) as IGameRoomCommandHadler);
					}
				}
			}
			return num;
        }

        protected void RegisterCommandHandler(int code, IGameRoomCommandHadler handle)
        {
			handles.Add(code, handle);
        }
    }
}
