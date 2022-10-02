using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.Farm.Handle
{
    public class FarmHandleMgr
    {
        private Dictionary<int, IFarmCommandHadler> handles = new Dictionary<int, IFarmCommandHadler>();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public IFarmCommandHadler LoadCommandHandler(int code)
        {
			if (handles.ContainsKey(code))
			{
				return handles[code];
			}
			log.Error("LoadCommandHandler code001: " + code);
			return null;
        }

        public FarmHandleMgr()
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
				if (type.IsClass && !(type.GetInterface("Game.Server.Farm.Handle.IFarmCommandHadler") == null))
				{
					FarmHandleAttbute[] array = (FarmHandleAttbute[])type.GetCustomAttributes(typeof(FarmHandleAttbute), inherit: true);
					if (array.Length != 0)
					{
						num++;
						RegisterCommandHandler(array[0].Code, Activator.CreateInstance(type) as IFarmCommandHadler);
					}
				}
			}
			return num;
        }

        protected void RegisterCommandHandler(int code, IFarmCommandHadler handle)
        {
			handles.Add(code, handle);
        }
    }
}
