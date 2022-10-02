using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;
using System.Net;

namespace AdminGunny
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public bool IsUrlAvailable(string url)
        {
            try
            {
                HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);


                using (HttpWebResponse rsp = (HttpWebResponse)req.GetResponse())
                {
                    if (rsp.StatusCode == HttpStatusCode.OK)
                    {
                        return true;
                    }
                }
            }
            catch (WebException)
            {
                // Eat it because all we want to do is return false
            }


            // Otherwise
            return false;
        }
        public string GetXML(string strPath, string strKey)
        {
            string strFileName = strPath + ".xml";
            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath(strFileName));

            XmlNodeList xNodeList = xDoc.SelectNodes(strKey + "/child::node()");
            string stringOutPut = "";
            stringOutPut += "<div class=\"menu\" id=\"NavigationMenu2\"><ul class=\"level1\">";

            foreach (XmlNode xNode in xNodeList)
            {
                string xml_Name = xNode.Attributes["Name"].Value == "" ? "NULL" : xNode.Attributes["Name"].Value;
                string xml_Script = xNode.Attributes["Script"].Value == "" ? "NULL" : xNode.Attributes["Script"].Value;
                stringOutPut += "<li><a  href=\"javascript:void(0);\" class=\"level1\" id=\"menuloaddata\" onclick=\"" + xml_Script + ";\">" + xml_Name + "</a></li>";
            }

            stringOutPut += "</ul></div>";
            return stringOutPut;
        }
    }
}
