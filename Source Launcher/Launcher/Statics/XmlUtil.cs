using System.Text;
using System.Xml;
using Newtonsoft.Json;

namespace Launcher.Statics
{
	public class XmlUtil
	{
		private static XmlUtil wf9l4ZTMVVLJUW6VWOK;

		public static string XmlNodeToString(XmlNode xmlNode)
		{
			StringBuilder stringBuilder = new StringBuilder(JsonConvert.SerializeObject(xmlNode.Attributes));
			stringBuilder.Replace("{\"", "\"");
			stringBuilder.Replace("\"}", "\"");
			stringBuilder.Replace("[", "");
			stringBuilder.Replace("]", "");
			stringBuilder.Replace("@", "");
			return string.Concat("{" + stringBuilder.ToString(), "}");
		}

		public static TJData Deserialize<TJData>(string jsonDatas)
		{
			return JsonConvert.DeserializeObject<TJData>(jsonDatas);
		}

		internal static bool QhZB9gTbR4vNNNatSbN()
		{
			return wf9l4ZTMVVLJUW6VWOK == null;
		}

		internal static void jO7ieyTEwkT24HP5G0c()
		{
		}

		internal static void suKySSTHvPFoaU8pGWb()
		{
		}
	}
}
