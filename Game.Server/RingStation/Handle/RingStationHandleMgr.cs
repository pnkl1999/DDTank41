using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.RingStation.Handle
{
    public class RingStationHandleMgr
    {
        private Dictionary<int, IRingStationCommandHadler> handles = new Dictionary<int, IRingStationCommandHadler>();

        public IRingStationCommandHadler LoadCommandHandler(int code)
        {
            if (handles.ContainsKey(code))
                return handles[code];
            log.Error("LoadCommandHandler code025: " + code.ToString());
            return null;
        }

        private static readonly log4net.ILog log =
            log4net.LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public RingStationHandleMgr()
        {
            handles.Clear();
            SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }

        protected int SearchCommandHandlers(Assembly assembly)
        {
            int count = 0;
            foreach (Type type in assembly.GetTypes())
            {
                if (type.IsClass != true)
                    continue;
                if (type.GetInterface("Game.Server.RingStation.Handle.IRingStationCommandHadler") == null)
                    continue;

                RingStationHandleAttbute[] attr =
                    (RingStationHandleAttbute[]) type.GetCustomAttributes(typeof(RingStationHandleAttbute), true);
                if (attr.Length > 0)
                {
                    count++;
                    RegisterCommandHandler(attr[0].Code, Activator.CreateInstance(type) as IRingStationCommandHadler);
                }
            }

            return count;
        }

        protected void RegisterCommandHandler(int code, IRingStationCommandHadler handle)
        {
            handles.Add(code, handle);
        }
    }
}