using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.LittleGame.Handle
{
    public class LittleGameHandleMgr
    {
        private Dictionary<int, ILittleGameCommandHandler> handlers;

        public LittleGameHandleMgr()
        {
			handlers = new Dictionary<int, ILittleGameCommandHandler>();
			handlers.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }

        public ILittleGameCommandHandler LoadCommandHandler(int code)
        {
			return handlers[code];
        }

        protected void RegisterCommandHandler(int code, ILittleGameCommandHandler handle)
        {
			handlers.Add(code, handle);
        }

        protected int SearchCommandHandlers(Assembly assembly)
        {
			int num = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.LittleGame.Handle.ILittleGameCommandHandler") == null))
				{
					LittleGameAttribute[] array = (LittleGameAttribute[])type.GetCustomAttributes(typeof(LittleGameAttribute), inherit: true);
					if (array.Length != 0)
					{
						num++;
						RegisterCommandHandler(array[0].GetByteCode(), Activator.CreateInstance(type) as ILittleGameCommandHandler);
					}
				}
			}
			return num;
        }
    }
}
