using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Text;

namespace Tank.Request.CelebList
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class CreateAllCeleb : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
            {
                StringBuilder bulid = new StringBuilder();
                bulid.Append(CelebByGpList.Build());       //个人经验(等级)总排名
                bulid.Append(CelebByDayGPList.Build());    //个人经验(等级)日增长排名
                bulid.Append(CelebByWeekGPList.Build());   //个人经验(等级)周增长排名
                bulid.Append(CelebByOfferList.Build());    //个人功勋总排名
                bulid.Append(CelebByDayOfferList.Build()); //个人功勋日增长排名
                bulid.Append(CelebByWeekOfferList.Build());//个人功勋周增长排名
                bulid.Append(CelebByDayFightPowerList.Build());//个人战斗力排名

                bulid.Append(CelebByConsortiaRiches.Build());    //公会财富总排名
                bulid.Append(CelebByConsortiaDayRiches.Build()); //公会财富日增长排名
                bulid.Append(CelebByConsortiaWeekRiches.Build());//会会财富周增长排名
                bulid.Append(CelebByConsortiaHonor.Build());     //公会功勋总排名
                bulid.Append(CelebByConsortiaDayHonor.Build());  //公会功勋日增长排名
                bulid.Append(CelebByConsortiaWeekHonor.Build()); //公会功勋周增长排名
                bulid.Append(CelebByConsortiaLevel.Build());     //公会等级总排名
                bulid.Append(CelebByDayBestEquip.Build());       //最好装备
                bulid.Append(celebbyconsortiafightpower.Build()); // xep hang luc chien guild

                context.Response.ContentType = "text/plain";
                context.Response.Write(bulid.ToString());
            }
            else
            {
                context.Response.Write("IP is not valid!" + context.Request.UserHostAddress);
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
