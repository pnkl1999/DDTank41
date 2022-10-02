using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Xml.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdminGunny.XMLReader
{
    public partial class XMLReader : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //*
            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(Server.MapPath("XMLImport/BallList.xml"));

            XmlNodeList xNodeList = xDoc.SelectNodes("Result/child::node()");
            //XmlNodeList xNodeList = xDoc.ChildNodes;
            int contNode = 1;
            foreach (XmlNode xNode in xNodeList)
            {

                string xml_ID = xNode.Attributes["ID"].Value == "" ? "NULL" : xNode.Attributes["ID"].Value;
                string xml_Power = xNode.Attributes["Power"].Value == "" ? "NULL" : xNode.Attributes["Power"].Value;
                string xml_Radii = xNode.Attributes["Radii"].Value == "" ? "NULL" : xNode.Attributes["Radii"].Value;
                string xml_FlyingPartical = xNode.Attributes["FlyingPartical"].Value == "" ? "NULL" : xNode.Attributes["FlyingPartical"].Value;
                string xml_BombPartical = xNode.Attributes["BombPartical"].Value == "" ? "NULL" : xNode.Attributes["BombPartical"].Value;
                string xml_Crater = xNode.Attributes["Crater"].Value == "" ? "NULL" : xNode.Attributes["Crater"].Value;
                string xml_AttackResponse = xNode.Attributes["AttackResponse"].Value == "" ? "NULL" : xNode.Attributes["AttackResponse"].Value;
                string xml_IsSpin = xNode.Attributes["IsSpin"].Value == "" ? "NULL" : xNode.Attributes["IsSpin"].Value;
                string xml_SpinV = xNode.Attributes["SpinV"].Value == "" ? "NULL" : xNode.Attributes["SpinV"].Value;
                string xml_SpinVA = xNode.Attributes["SpinVA"].Value == "" ? "NULL" : xNode.Attributes["SpinVA"].Value;
                string xml_Amount = xNode.Attributes["Amount"].Value == "" ? "NULL" : xNode.Attributes["Amount"].Value;
                string xml_Wind = xNode.Attributes["Wind"].Value == "" ? "NULL" : xNode.Attributes["Wind"].Value;
                string xml_DragIndex = xNode.Attributes["DragIndex"].Value == "" ? "NULL" : xNode.Attributes["DragIndex"].Value;
                string xml_Weight = xNode.Attributes["Weight"].Value == "" ? "NULL" : xNode.Attributes["Weight"].Value;
                string xml_Shake = xNode.Attributes["Shake"].Value == "" ? "NULL" : xNode.Attributes["Shake"].Value;
                string xml_ShootSound = xNode.Attributes["ShootSound"].Value == "" ? "NULL" : xNode.Attributes["ShootSound"].Value;
                string xml_BombSound = xNode.Attributes["BombSound"].Value == "" ? "NULL" : xNode.Attributes["BombSound"].Value;
                string xml_ActionType = xNode.Attributes["ActionType"].Value == "" ? "NULL" : xNode.Attributes["ActionType"].Value;
                string xml_Mass = xNode.Attributes["Mass"].Value == "" ? "NULL" : xNode.Attributes["Mass"].Value; 
                    //Response.Write(xNode.Attributes["ID"].Value);
                    view_xml.Text += "<font color='red'>ID:</font><font color='blue'> " + xml_ID +
                                    "<font color='red'>Name:</font><font color='blue'>  Weapon" + contNode +
                                    "</font><font color='red'> Power:</font><font color='blue'> " + xml_Power +
                                    "</font><font color='red'> Radii:</font><font color='blue'> " + xml_Radii +
                                    "</font><font color='red'> FlyingPartical:</font><font color='blue'> " + xml_FlyingPartical +
                                    "</font><font color='red'> BombPartical:</font><font color='blue'> " + xml_BombPartical +
                                    "</font><font color='red'> Crater:</font><font color='blue'> " + xml_Crater +
                                    "</font><font color='red'> AttackResponse:</font><font color='blue'> " + xml_AttackResponse +
                                    "</font><br/>";
                    contNode++;
                     
                
            }
            //*/
            /*
            XmlDocument xDoc2 = new XmlDocument();
            xDoc2.Load(Server.MapPath("BallList_Out.xml"));
            XmlNodeList xNodeList2 = xDoc2.SelectNodes("root/child::node()");
            //Traverse the entire XML nodes.
            foreach (XmlNode xNode in xNodeList2)
            {
                if (xNode.Name == "Result")
                {
                    //If the parent node has child nodes then 
                    //traverse the child nodes
                    foreach (XmlNode xNode1 in xNode.ChildNodes)
                    {
                        string xml_string = "";                       
                        //Loop through each attribute of the child nodes
                        foreach (XmlAttribute xAtt in xNode1.Attributes)
                        {
                            
                            //Response.Write(xAtt.Name);   //Outputs: id
                            //Response.Write("<br>");
                            //Response.Write(xAtt.Value); //Outputs: 1
                            //Response.Write("<br>");
                             
                            xml_string += "<font color='red'>" + xAtt.Name + "</font><font color='blue'> " + xAtt.Value + "</font>";
                        }
                        Response.Write(xml_string);
                        Response.Write("<br/>");
                    }
                }
            }
             */ 
        }
    }
}