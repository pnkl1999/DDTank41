using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using log4net;
using System.Reflection;
using SqlDataProvider.Data;
using Bussiness;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class LoadUserMail : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";

            XElement result = new XElement("Result");
            try
            {
                int id = int.Parse(context.Request.QueryString["selfid"]);
                if (id != 0)
                {
                    using (PlayerBussiness db = new PlayerBussiness())
                    {
                        MailInfo[] infos = db.GetMailByUserID(id);

                        foreach (MailInfo info in infos)
                        {
                            //TimeSpan days = DateTime.Now.Subtract(info.SendTime);
                            XElement node = new XElement("Item", new XAttribute("ID", info.ID),
                                                    new XAttribute("Title", info.Title),
                                                    new XAttribute("Content", info.Content),
                                                    new XAttribute("Sender", info.Sender),
                                                    new XAttribute("SendTime", info.SendTime.ToString("yyyy-MM-dd HH:mm:ss")),
                                                    //new XAttribute("Days", info.ValidDate/24 - days.Days ),
                                                    new XAttribute("Gold", info.Gold),
                                                    new XAttribute("Money", info.Money),
                                                    new XAttribute("Annex1ID", info.Annex1 == null ? "" : info.Annex1),
                                                    new XAttribute("Annex2ID", info.Annex2 == null ? "" : info.Annex2),
                                                    new XAttribute("Annex3ID", info.Annex3 == null ? "" : info.Annex3),
                                                    new XAttribute("Annex4ID", info.Annex4 == null ? "" : info.Annex4),
                                                    new XAttribute("Annex5ID", info.Annex5 == null ? "" : info.Annex5),
                                                    new XAttribute("Type", info.Type),
                                                    new XAttribute("ValidDate", info.ValidDate),
                                                    new XAttribute("IsRead", info.IsRead));

                            AddAnnex(node, info.Annex1);
                            AddAnnex(node, info.Annex2);
                            AddAnnex(node, info.Annex3);
                            AddAnnex(node, info.Annex4);
                            AddAnnex(node, info.Annex5);

                            //using (PlayerBussiness pb = new PlayerBussiness())
                            //{
                            //    if (!string.IsNullOrEmpty(info.Annex1))
                            //    {
                            //        ItemInfo pr = pb.GetUserItemSingle(int.Parse(info.Annex1));
                            //        if (pr != null)
                            //        {
                            //            node.Add(Road.Flash.FlashUtils.CreateGoodsInfo(pr));
                            //        }
                            //    }

                            //    if (!string.IsNullOrEmpty(info.Annex2))
                            //    {
                            //        ItemInfo pr = pb.GetUserItemSingle(int.Parse(info.Annex2));
                            //        if (pr != null)
                            //        {
                            //            node.Add(Road.Flash.FlashUtils.CreateGoodsInfo(pr));
                            //        }
                            //    }
                            //    if (!string.IsNullOrEmpty(info.Annex3))
                            //    {
                            //        ItemInfo pr = pb.GetUserItemSingle(int.Parse(info.Annex3));
                            //        if (pr != null)
                            //        {
                            //            node.Add(Road.Flash.FlashUtils.CreateGoodsInfo(pr));
                            //        }
                            //    }
                            //    if (!string.IsNullOrEmpty(info.Annex4))
                            //    {
                            //        ItemInfo pr = pb.GetUserItemSingle(int.Parse(info.Annex4));
                            //        if (pr != null)
                            //        {
                            //            node.Add(Road.Flash.FlashUtils.CreateGoodsInfo(pr));
                            //        }
                            //    }
                            //    if (!string.IsNullOrEmpty(info.Annex5))
                            //    {
                            //        ItemInfo pr = pb.GetUserItemSingle(int.Parse(info.Annex5));
                            //        if (pr != null)
                            //        {
                            //            node.Add(Road.Flash.FlashUtils.CreateGoodsInfo(pr));
                            //        }
                            //    }
                            //}
                            result.Add(node);
                        }

                        //MailInfo[] sInfos = db.GetMailBySenderID(id);
                        //foreach (MailInfo info in sInfos)
                        //{
                        //    result.Add(Road.Flash.FlashUtils.CreateMailInfo(info,"SendMail"));
                        //}

                    }
            
                    value = true;
                    message = "Success!";
                }

            }
            catch (Exception ex)
            {
                log.Error("LoadUserMail", ex);
            }

            result.Add(new XAttribute("value", value));
            result.Add(new XAttribute("message", message));

            context.Response.ContentType = "text/plain";
            //context.Response.Write(result.ToString(false));
            //DDTank
            context.Response.BinaryWrite(StaticFunction.Compress(result.ToString(false)));

        }
        
        public static void AddAnnex(XElement node, string value)
        {
            using (PlayerBussiness pb = new PlayerBussiness())
            {
                if (!string.IsNullOrEmpty(value))
                {
                    ItemInfo pr = pb.GetUserItemSingle(int.Parse(value));
                    if (pr != null)
                    {
                        node.Add(Road.Flash.FlashUtils.CreateGoodsInfo(pr));
                    }
                }
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
