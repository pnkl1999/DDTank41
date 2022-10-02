using System;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Text;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class CreateAllXml : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            if (csFunction.ValidAdminIP(context.Request.UserHostAddress))
            {
                StringBuilder build = new StringBuilder();
                build.Append(ActiveList.Bulid(context));
                build.Append(BallList.Bulid(context));
                build.Append(LoadMapsItems.Bulid(context));
                build.Append(LoadPVEItems.Build(context));
                build.Append(QuestList.Bulid(context));
                build.Append(TemplateAllList.Bulid(context));
                build.Append(ShopItemList.Bulid(context));
                build.Append(LoadItemsCategory.Bulid(context));
                build.Append(ItemStrengthenList.Bulid(context));
                build.Append(MapServerList.Bulid(context));
                build.Append(ConsortiaLevelList.Bulid(context));
                build.Append(DailyAwardList.Bulid(context));
                build.Append(NPCInfoList.Bulid(context));

                //25-07-2021
                build.Append(LoginAwardItemTemplate.Bulid(context));
                build.Append(eventrewarditemlist.Bulid(context));
                build.Append(serverconfig.Bulid(context));
                build.Append(ShopGoodsShowList.Bulid(context));
                build.Append(newtitle.Bulid(context));

                //22-11-2021
                build.Append(petskillelementinfo.Bulid(context));
                build.Append(petskillinfo.Bulid(context));
                build.Append(petskilltemplateinfo.Bulid(context));
                build.Append(pettemplateinfo.Bulid(context));
                build.Append(CardUpdateCondition.Bulid(context));
                build.Append(CardUpdateInfo.Bulid(context));

                //26-01-2022
                build.Append(activitysystemitems.Build(context));
                build.Append(suittemplateinfolist.Build(context));
                build.Append(DailyLeagueLevelList.Build(context));
                build.Append(DailyLeagueAwardList.Build(context));
                context.Response.ContentType = "text/plain";
                context.Response.Write(build.ToString());

            }
            else
            {
                context.Response.Write("IP is not valid!");
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
