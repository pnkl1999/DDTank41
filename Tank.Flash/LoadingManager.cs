using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Threading;
using SqlDataProvider.Data;

namespace Tank.Flash
{
    public class LoadingManager
    {
        public static int LoadingCount = 0;

        private static Dictionary<string, PlayerData> m_players = new Dictionary<string, PlayerData>();

        private static object sys_obj = new object();

        private static Timer m_timer;

        private static int m_timeout = 30;   // 分钟

        public static void Setup()
        {
            m_timeout = int.Parse(ConfigurationManager.AppSettings["LoginSessionTimeOut"]);
            m_timer = new Timer(new TimerCallback(CheckTimerCallback), null, 0, 60 * 1000);
        }

        protected static bool CheckTimeOut(DateTime dt)
        {
            return (DateTime.Now - dt).TotalMinutes > m_timeout;
        }

        private static void CheckTimerCallback(object state)
        {
            lock (sys_obj)
            {
                List<string> list = new List<string>();
                foreach (PlayerData p in m_players.Values)
                {
                    if (CheckTimeOut(p.Date))
                    {
                        list.Add(p.Name);
                    }
                }
                foreach (string name in list)
                {
                    m_players.Remove(name);
                }
            }
        }
        public static void Add(string name, string pass)
        {
            Add(name, pass, false);
        }
        public static void Add(string name, string pass, bool isAdmin)
        {
            lock (sys_obj)
            {
                if (m_players.ContainsKey(name))
                {
                    m_players[name].Name = name;
                    m_players[name].Pass = pass;
                    m_players[name].Date = DateTime.Now;
                    m_players[name].Count = 0;
                    m_players[name].IsAdmin = isAdmin;
                }
                else
                {
                    PlayerData data = new PlayerData();
                    data.Name = name;
                    data.Pass = pass;
                    data.Date = DateTime.Now;
                    data.IsAdmin = isAdmin;
                    m_players.Add(name, data);
                }
            }
        }

        public static bool Login(string name, string pass)
        {
            lock (sys_obj)
            {
                if (m_players.ContainsKey(name) && m_players[name].Pass == pass)
                {
                    PlayerData p = m_players[name];
                    if (p.Pass == pass && !CheckTimeOut(p.Date))
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
        }

        public static bool Update(string name, string pass)
        {
            lock (sys_obj)
            {
                if (m_players.ContainsKey(name))
                {
                    m_players[name].Pass = pass;
                    m_players[name].Count++;
                    return true;
                }
            }
            return false;
        }
        public static bool UpdateKey(string name, string key)
        {
            lock (sys_obj)
            {
                if (m_players.ContainsKey(name))
                {
                    m_players[name].Key = key;
                    return true;
                }
            }
            return false;
        }
        public static bool Remove(string name)
        {
            lock (sys_obj)
            {
                return m_players.Remove(name);
            }
        }
        public static bool CheckUser(string name)
        {
            lock (sys_obj)
            {
                if (m_players.ContainsKey(name))
                    return true;
            }
            return false;
        }
        public static bool GetByUserIsFirst(string name)
        {
            lock (sys_obj)
            {
                if (m_players.ContainsKey(name))
                    return m_players[name].Count == 0;
            }
            return false;
        }

        class PlayerData
        {
            public string Name;
            public string Pass;
            public string Key;
            public DateTime Date;
            public int Count;
            public bool IsAdmin;
        }
    }
}
