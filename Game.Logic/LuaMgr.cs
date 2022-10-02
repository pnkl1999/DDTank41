using System;
using System.Collections.Generic;
using LuaInterface;

namespace Game.Logic
{
	public class LuaMgr
	{
		private static Queue<Lua> m_queue = new Queue<Lua>();

		public static void Setup(int init)
		{
			for (int i = 0; i < init; i++)
			{
				m_queue.Enqueue(new Lua());
			}
		}

		public static Lua AllocateLua()
		{
			Lua lua = null;
			lock (m_queue)
			{
				if (m_queue.Count > 0)
				{
					lua = m_queue.Dequeue();
				}
			}
			if (lua == null)
			{
				lua = new Lua();
			}
			return lua;
		}

		public static void ReleaseLua(Lua lua)
		{
			lock (m_queue)
			{
				m_queue.Enqueue(lua);
				Console.WriteLine("lua queue count:{0}", m_queue.Count);
			}
		}
	}
}
