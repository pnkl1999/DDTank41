using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.RingStation.RoomGamePkg.TankHandle
{
    public class GameCommandMgr
    {
        private Dictionary<int, IGameCommandHandler> handles = new Dictionary<int, IGameCommandHandler>();

        public GameCommandMgr()
        {
            handles.Clear();
            SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }

        public IGameCommandHandler LoadCommandHandler(int code)
        {
            if (handles.ContainsKey(code))
                return handles[code];
            log.Error("LoadCommandHandler code026: " + code.ToString());
            return null;
        }

        private static readonly log4net.ILog log =
            log4net.LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        protected void RegisterCommandHandler(int code, IGameCommandHandler handle)
        {
            handles.Add(code, handle);
        }

        protected int SearchCommandHandlers(Assembly assembly)
        {
            int num = 0;
            foreach (Type type in assembly.GetTypes())
            {
                if (type.IsClass &&
                    (type.GetInterface("Game.Server.RingStation.RoomGamePkg.TankHandle.IGameCommandHandler") != null))
                {
                    GameCommandAttbute[] customAttributes =
                        (GameCommandAttbute[]) type.GetCustomAttributes(typeof(GameCommandAttbute), true);
                    if (customAttributes.Length > 0)
                    {
                        num++;
                        RegisterCommandHandler(customAttributes[0].Code,
                            Activator.CreateInstance(type) as IGameCommandHandler);
                    }
                }
            }

            return num;
        }
    }
}