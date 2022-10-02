using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Tank.Data
{
    public class ServerPropertyMgr
    {
        private static Dictionary<string, ServerProperty> _serverPropertys = new Dictionary<string, ServerProperty>();
        private static int _nextId = 0;

        public static int NextId() => Interlocked.Increment(ref ServerPropertyMgr._nextId);

        public static bool Init() => ServerPropertyMgr.ReLoad();

        public static bool ReLoad()
        {
            try
            {
                Dictionary<string, ServerProperty> dictionary = ServerPropertyMgr.LoadFromDatabase();
                if (dictionary.Values.Count > 0)
                {
                    Interlocked.Exchange<Dictionary<string, ServerProperty>>(ref ServerPropertyMgr._serverPropertys, dictionary);
                    ServerPropertyMgr._nextId = dictionary.Count;
                    return true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("ServerPropertyMgr init error:" + ex.ToString());
            }
            return false;
        }

        private static Dictionary<string, ServerProperty> LoadFromDatabase()
        {
            Dictionary<string, ServerProperty> dictionary = new Dictionary<string, ServerProperty>();
            using (ProduceBussiness produceBussiness = new ProduceBussiness())
            {
                foreach (ServerProperty serverProperty in produceBussiness.GetAllServerProperty())
                {
                    if (!dictionary.ContainsKey(serverProperty.Name))
                        dictionary.Add(serverProperty.Name, serverProperty);
                }
            }
            return dictionary;
        }

        public static List<ServerProperty> GetAllServerProperty()
        {
            if (ServerPropertyMgr._serverPropertys.Count == 0)
                ServerPropertyMgr.Init();
            return ServerPropertyMgr._serverPropertys.Values.ToList<ServerProperty>();
        }

        public static ServerProperty FindServerProperty(string name)
        {
            if (ServerPropertyMgr._serverPropertys.Count == 0)
                ServerPropertyMgr.Init();
            return ServerPropertyMgr._serverPropertys.ContainsKey(name) ? ServerPropertyMgr._serverPropertys[name] : (ServerProperty)null;
        }
    }
}
