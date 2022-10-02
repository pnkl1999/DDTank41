using System.Collections;
using System.IO;
using System.Text;
using System.Xml;

namespace Game.Base.Config
{
    public class XMLConfigFile : ConfigElement
    {
        public XMLConfigFile()
			: base(null)
        {
        }

        protected XMLConfigFile(ConfigElement parent)
			: base(parent)
        {
        }

        protected bool IsBadXMLElementName(string name)
        {
			if (name != null)
			{
				if (name.IndexOf("\\") == -1 && name.IndexOf("/") == -1 && name.IndexOf("<") == -1)
				{
					return name.IndexOf(">") != -1;
				}
				return true;
			}
			return false;
        }

        public static XMLConfigFile ParseXMLFile(FileInfo configFile)
        {
			XMLConfigFile file = new XMLConfigFile(null);
			if (configFile.Exists)
			{
				ConfigElement parent = file;
				XmlTextReader reader = new XmlTextReader(configFile.OpenRead());
				while (reader.Read())
				{
					if (reader.NodeType == XmlNodeType.Element)
					{
						if (!(reader.Name != "root"))
						{
							continue;
						}
						if (reader.Name == "param")
						{
							string attribute = reader.GetAttribute("name");
							if (attribute != null && attribute != "root")
							{
								ConfigElement configElement2 = (parent[attribute] = new ConfigElement(parent));
								ConfigElement element2 = configElement2;
								parent = element2;
							}
						}
						else
						{
							ConfigElement element3 = new ConfigElement(parent);
							parent[reader.Name] = element3;
							parent = element3;
						}
					}
					else if (reader.NodeType == XmlNodeType.Text)
					{
						parent.Set(reader.Value);
					}
					else if (reader.NodeType == XmlNodeType.EndElement && reader.Name != "root")
					{
						parent = parent.Parent;
					}
				}
				reader.Close();
			}
			return file;
        }

        public void Save(FileInfo configFile)
        {
			if (configFile.Exists)
			{
				configFile.Delete();
			}
			XmlTextWriter writer = new XmlTextWriter(configFile.FullName, Encoding.UTF8)
			{
				Formatting = Formatting.Indented
			};
			writer.WriteStartDocument();
			SaveElement(writer, null, this);
			writer.WriteEndDocument();
			writer.Close();
        }

        protected void SaveElement(XmlTextWriter writer, string name, ConfigElement element)
        {
			bool flag = IsBadXMLElementName(name);
			if (element.HasChildren)
			{
				if (name == null)
				{
					name = "root";
				}
				if (flag)
				{
					writer.WriteStartElement("param");
					writer.WriteAttributeString("name", name);
				}
				else
				{
					writer.WriteStartElement(name);
				}
				foreach (DictionaryEntry entry in element.Children)
				{
					SaveElement(writer, (string)entry.Key, (ConfigElement)entry.Value);
				}
				writer.WriteEndElement();
			}
			else if (name != null)
			{
				if (flag)
				{
					writer.WriteStartElement("param");
					writer.WriteAttributeString("name", name);
					writer.WriteString(element.GetString());
					writer.WriteEndElement();
				}
				else
				{
					writer.WriteElementString(name, element.GetString());
				}
			}
        }
    }
}
