using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Linq;

namespace AdminGunny.XMLReader
{
    public partial class printVar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string xmlFile = TextBox1.Text;
            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/" + xmlFile));

            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");
            XmlNode xNode = xNodeList[0]; //1 ChildNodes
            //XmlNode xNode = xNodeList[0].ChildNodes[0]; //2 ChildNodes
            //Response.Write(xNode[0].Attributes.Count);
            Response.Write(xNode.Attributes.Count);
            string srtStoreP = "";//"int kq = db.st_XMLImport(";
                    foreach (XmlAttribute xAtt in xNode.Attributes)
                    {
                        string varName = "== \"\" ? null : xNode.Attributes[\"" + xAtt.Name + "\"].Value;";//Outputs:;
                        view_var.Text += "string xml_" + xAtt.Name + " = xNode.Attributes[\"" + xAtt.Name + "\"].Value " + varName + " <br/>";
                        //srtStoreP += ", xml_" + xAtt.Name;
                    }
                    //srtStoreP += ");";
                    Response.Write("<br/>");
                    Response.Write(srtStoreP);
            
        }
    }
}