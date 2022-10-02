using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.ConsortiaTask.Handle
{
    public class ConsortiaTaskHandleMgr
    {
        private Dictionary<int, IConsortiaTaskCommandHadler> handlers;

        public ConsortiaTaskHandleMgr()
        {
            handlers = new Dictionary<int, IConsortiaTaskCommandHadler>();
            handlers.Clear();
            SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }
        public IConsortiaTaskCommandHadler LoadCommandHandler(int code)
        {
            return this.handlers[code];
        }
        protected void RegisterCommandHandler(int code, IConsortiaTaskCommandHadler handle)
        {
            this.handlers.Add(code, handle);
        }
        protected int SearchCommandHandlers(Assembly assembly)
        {
            var num = 0;
            var types = assembly.GetTypes();
            foreach (var type in types)
            {
                if (!type.IsClass ||
                    type.GetInterface("Game.Server.ConsortiaTask.Handle.IConsortiaTaskCommandHadler") == null) continue;
                var customAttributes = (ConsortiaTaskAttribute[])type.GetCustomAttributes(typeof(ConsortiaTaskAttribute), true);
                if (customAttributes.Length == 0) continue;
                num++;
                RegisterCommandHandler(customAttributes[0].GetByteCode(), Activator.CreateInstance(type) as IConsortiaTaskCommandHadler);
            }
            return num;
        }
    }
}
