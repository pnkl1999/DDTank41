using System.Threading;
using System.Configuration;
using System.Collections.Generic;
using System;
using System.IO;
using log4net;
using System.Reflection;
using System.Text;
using Tank.Request.CelebList;
using Bussiness;
using System.Xml.Linq;
using SqlDataProvider.Data;
using Road.Flash;
using System.Web;
namespace Tank.Request
{
    public static class StaticsMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static Timer _timer;
        private static object _locker = new object();
        private static List<string> _list = new List<string>();
        private static int RegCount = 0;
        private static int pid;
        private static int did;
        private static int sid;
        private static string _path;
        private static long _interval;
        private static int CelebBuildDay;
        public static string CurrentPath;

        public static void Setup()
        {
            CurrentPath = HttpContext.Current.Server.MapPath("~");
            CelebBuildDay = DateTime.Now.Day;
            
            pid = int.Parse(ConfigurationManager.AppSettings["PID"]);
            did = int.Parse(ConfigurationManager.AppSettings["DID"]);
            sid = int.Parse(ConfigurationManager.AppSettings["SID"]);
            _path = ConfigurationManager.AppSettings["LogPath"];
            _interval = int.Parse(ConfigurationManager.AppSettings["LogInterval"]) * 60 * 1000;
            _timer = new Timer(new TimerCallback(OnTimer), null, 0, _interval);
            
            //StringBuilder bulid = new StringBuilder();

            //bulid.Append(CelebByGpList.Build());
            //bulid.Append(CelebByDayGPList.Build());
            //bulid.Append(CelebByWeekGPList.Build());
            //bulid.Append(CelebByOfferList.Build());
            //bulid.Append(CelebByDayOfferList.Build());
            //bulid.Append(CelebByWeekOfferList.Build());

            //bulid.Append(CelebByConsortiaRiches.Build());
            //bulid.Append(CelebByConsortiaDayRiches.Build());
            //bulid.Append(CelebByConsortiaWeekRiches.Build());
            //bulid.Append(CelebByConsortiaHonor.Build());
            //bulid.Append(CelebByConsortiaDayHonor.Build());
            //bulid.Append(CelebByConsortiaWeekHonor.Build());
            //bulid.Append(CelebByConsortiaLevel.Build());
            //bulid.Append(CelebByDayBestEquip.Build());
        }

        private static void OnTimer(object state)
        {
            try
            {
                lock (_locker)
                {
                    if (_list.Count > 0)
                    {
                        string filename = string.Format("{0}\\payment-{1:D2}{2:D2}{3:D2}-{4:yyyyMMdd}.log", _path, pid, did, sid, DateTime.Now);
                        using (FileStream fs = File.Open(filename, FileMode.Append))
                        {
                            using (StreamWriter writer = new StreamWriter(fs))
                            {
                                while (_list.Count != 0)
                                {
                                    writer.WriteLine(_list[0]);
                                    _list.RemoveAt(0);
                                }
                            }
                        }
                    }

                    if (RegCount > 0)
                    {
                        string filename = string.Format("{0}\\reg-{1:D2}{2:D2}{3:D2}-{4:yyyyMMdd}.log", _path, pid, did, sid, DateTime.Now);
                        using (FileStream fs = File.Open(filename, FileMode.Append))
                        {
                            using (StreamWriter writer = new StreamWriter(fs))
                            {
                                string str = string.Format("{0},{1},{2},{3},{4}", pid, did, sid, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), RegCount);
                                writer.WriteLine(str);
                                RegCount = 0;
                            }
                        } 
                    }
                }
            }
            catch (Exception ex)
            {
                log.Error("Save log error", ex);
            }

            if (CelebBuildDay != DateTime.Now.Day && DateTime.Now.Hour > 2 && DateTime.Now.Hour < 6)
            {
                CelebBuildDay = DateTime.Now.Day;
                StringBuilder bulid = new StringBuilder();
                try
                {
                    bulid.Append(CelebByGpList.Build());
                    bulid.Append(CelebByDayGPList.Build());
                    bulid.Append(CelebByWeekGPList.Build());
                    bulid.Append(CelebByOfferList.Build());
                    bulid.Append(CelebByDayOfferList.Build());
                    bulid.Append(CelebByWeekOfferList.Build());
                    bulid.Append(CelebByDayFightPowerList.Build());//fightpower

                    bulid.Append(CelebByConsortiaRiches.Build());
                    bulid.Append(CelebByConsortiaDayRiches.Build());
                    bulid.Append(CelebByConsortiaWeekRiches.Build());
                    bulid.Append(CelebByConsortiaHonor.Build());
                    bulid.Append(CelebByConsortiaDayHonor.Build());
                    bulid.Append(CelebByConsortiaWeekHonor.Build());
                    bulid.Append(CelebByConsortiaLevel.Build());
                    bulid.Append(CelebByDayBestEquip.Build());
                    log.Info("Complete auto update Celeb in " + DateTime.Now.ToString());
                }
                catch (Exception ex)
                {
                    bulid.Append("CelebByList is Error!");
                    log.Error(bulid.ToString(), ex);
                }
            }

        }

        public static void Log(DateTime dt, string username, bool sex, int money, string payway, decimal needMoney)
        {
            //合作伙伴,分区,服务器,时间,用户名,性别,数量,充值方式
            string str = string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8}", pid, did, sid, dt.ToString("yyyy-MM-dd HH:mm:ss"), username, sex ? 1 : 0, money, payway, needMoney);
            lock (_locker)
            {
                _list.Add(str);
            }
        }

        public static void RegCountAdd()
        {
            lock (_locker)
            {
                RegCount++;
            }
        }

        public static void Stop()
        {
            _timer.Dispose();
            OnTimer(null);
        }
 
    }
}