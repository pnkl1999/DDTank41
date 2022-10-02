using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using log4net;
using System.Reflection;
using System.Threading;
using SqlDataProvider.Data;
using Bussiness;


namespace Bussiness.Managers
{
    public class TotemHonorMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Dictionary<int, TotemHonorTemplateInfo> _totemHonorTemplate;
        private static Random rand;

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, TotemHonorTemplateInfo> tempConsortiaLevel = new Dictionary<int, TotemHonorTemplateInfo>();
                if (Load(tempConsortiaLevel))
                {
                    try
                    {
                        _totemHonorTemplate = tempConsortiaLevel;
                        return true;
                    }
                    catch
                    { }
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("TotemHonorMgr", e);
            }

            return false;
        }

        /// <summary>
        /// Initializes the StrengthenMgr. 
        /// </summary>
        /// <returns></returns>
        public static bool Init()
        {
            try
            {
                _totemHonorTemplate = new Dictionary<int, TotemHonorTemplateInfo>();
                rand = new Random();
                return Load(_totemHonorTemplate);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("TotemHonorMgr", e);
                return false;
            }

        }
        private static bool Load(Dictionary<int, TotemHonorTemplateInfo> TotemHonorTemplate)
        {
            using (ProduceBussiness db = new ProduceBussiness())
            {
                TotemHonorTemplateInfo[] infos = db.GetAllTotemHonorTemplate();
                foreach (TotemHonorTemplateInfo info in infos)
                {
                    if (!TotemHonorTemplate.ContainsKey(info.ID))
                    {
                        TotemHonorTemplate.Add(info.ID, info);
                    }
                }
            }

            return true;
        }
        public static TotemHonorTemplateInfo FindTotemHonorTemplateInfo(int ID)
        {
            if (_totemHonorTemplate.ContainsKey(ID))
                return _totemHonorTemplate[ID];

            return null;
        }


    }
}
