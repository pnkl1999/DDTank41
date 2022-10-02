using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.WorldBoss.Handle
{
    public class WorldBossHandleMgr
    {
        private Dictionary<int, IWorldBossCommandHandler> handles = new Dictionary<int, IWorldBossCommandHandler>();

        public IWorldBossCommandHandler LoadCommandHandler(int code)
        {
            return handles[code];
        }

        public WorldBossHandleMgr()
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
                if (type.GetInterface("Game.Server.WorldBoss.Handle.IWorldBossCommandHandler") == null)
                    continue;

                WorldBossHandleAttribute[] attr = (WorldBossHandleAttribute[]) type.GetCustomAttributes(typeof(WorldBossHandleAttribute), true);
                if (attr.Length > 0)
                {
                    count++;
                    RegisterCommandHandler(attr[0].Code, Activator.CreateInstance(type) as IWorldBossCommandHandler);
                }
            }

            return count;
        }

        protected void RegisterCommandHandler(int code, IWorldBossCommandHandler handle)
        {
            handles.Add(code, handle);
        }
    }
}