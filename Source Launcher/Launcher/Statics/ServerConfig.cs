using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Linq;
using System.Xml;
using Launcher.Properties;
using Properties;

namespace Launcher.Statics
{
	public class ServerConfig
	{
		public static Dictionary<int, ServerListInfo> Servers;

		public static Dictionary<string, SlideInfo> Slides;

		public static List<ServerListInfo> ExitServerPlay;

		public static string ClientGun321;

		public static string PathClient;

		public static string Version;

		public static string SiteName;

		public static string AccountInfoUrl;

		public static string PayUrl;

		public static string SuportUrl;

		public static string DailyLogUrl;

		public static string PlayMode;

		public static float ConfigXu;

        public static string MOMO_PHONE_NUMBER { get; private set; }
        public static string MOMO_ACCOUNT_NAME { get; private set; }

        public static bool Init(string datas)
		{
			Clear();
			try
			{
				XmlDocument xmlDocument = new XmlDocument();
				xmlDocument.LoadXml(datas);
				XmlNodeList xmlNodeList = xmlDocument.SelectNodes("Result/child::node()");
				new List<ServerListInfo>();
				foreach (XmlNode item in xmlNodeList)
				{
					if (item.Name == "Play" && item.ChildNodes.Count > 0)
					{
						foreach (XmlNode childNode in item.ChildNodes)
						{
							ServerListInfo serverListInfo = DecodeServerListInfo(childNode);
							if (serverListInfo != null)
							{
								serverListInfo.ImgeHover = drawImageServerName(serverListInfo.Name, Resources.serverBg2, Color.Black);
								serverListInfo.ImgeLeave = drawImageServerName(serverListInfo.Name, Resources.serverBg2, Color.White);
								ExitServerPlay.Add(serverListInfo);
							}
						}
					}
					if (item.Name == "List")
					{
						foreach (XmlNode childNode2 in item.ChildNodes)
						{
							ServerListInfo serverListInfo2 = DecodeServerListInfo(childNode2);
							if (serverListInfo2 != null && !Servers.ContainsKey(serverListInfo2.ID))
							{
								serverListInfo2.ImgeHover = drawImageServerName(serverListInfo2.Name, Resources.serverBg1, Color.Black);
								serverListInfo2.ImgeLeave = drawImageServerName(serverListInfo2.Name, Resources.serverBg1, Color.White);
								Servers.Add(serverListInfo2.ID, serverListInfo2);
							}
						}
					}
					if (item.Name == "Slide")
					{
						foreach (XmlNode childNode3 in item.ChildNodes)
						{
							DecodeSlideInfo(childNode3);
						}
					}
					if (item.Name == "Config")
					{
						SetUpConfig(item.ChildNodes);
					}
					if (!(item.Name == "Update"))
					{
						continue;
					}
					foreach (XmlNode childNode4 in item.ChildNodes)
					{
						if (childNode4.Attributes["ClientGun321"] != null)
						{
							ClientGun321 = childNode4.Attributes["ClientGun321"].Value.ToString();
						}
						if (childNode4.Attributes["PathClient"] != null)
						{
							PathClient = childNode4.Attributes["PathClient"].Value.ToString();
						}
					}
				}
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception 12 " + ex.Message, ex.ToString());
				return false;
			}
			return true;
		}

		private static Image drawImageServerName(string string_0, Image image_0, Color color_0)
		{
			Bitmap bitmap = new Bitmap(image_0);
			using Graphics graphics = Graphics.FromImage(bitmap);
			graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
			graphics.SmoothingMode = SmoothingMode.HighQuality;
			graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
			graphics.CompositingQuality = CompositingQuality.HighQuality;
			using (SolidBrush brush = new SolidBrush(color_0))
			{
				using Font font = new Font("Microsoft Sans Serif", 16f, FontStyle.Bold, GraphicsUnit.Pixel);
				graphics.DrawString(string_0, font, brush, 50f, 13f);
			}
			graphics.Save();
			return bitmap;
		}

		public static void SetUpConfig(XmlNodeList list)
		{
			foreach (XmlNode item in list)
			{
				if (item.Attributes["Version"] != null)
				{
					Version = item.Attributes["Version"].Value.ToString();
				}
				if (item.Attributes["SiteName"] != null)
				{
					SiteName = item.Attributes["SiteName"].Value.ToString();
				}
				if (item.Attributes["AccountInfoUrl"] != null)
				{
					AccountInfoUrl = item.Attributes["AccountInfoUrl"].Value.ToString();
				}
				if (item.Attributes["PayUrl"] != null)
				{
					PayUrl = item.Attributes["PayUrl"].Value.ToString();
				}
				if (item.Attributes["SuportUrl"] != null)
				{
					SuportUrl = item.Attributes["SuportUrl"].Value.ToString();
				}
				if (item.Attributes["DailyLogUrl"] != null)
				{
					DailyLogUrl = item.Attributes["DailyLogUrl"].Value.ToString();
				}
				if (item.Attributes["PlayMode"] != null)
				{
					PlayMode = item.Attributes["PlayMode"].Value.ToString();
				}
				if (item.Attributes["ConfigXu"] != null)
				{
					float number;

					bool success = float.TryParse(item.Attributes["ConfigXu"].Value.ToString(), out number);
					if (!success)
					{
						number = 0;
					}
					ConfigXu = number;
				}

				if (item.Attributes["MOMO_ACCOUNT_NAME"] != null)
				{
					MOMO_ACCOUNT_NAME = item.Attributes["MOMO_ACCOUNT_NAME"].Value.ToString();
				}

				if (item.Attributes["MOMO_PHONE_NUMBER"] != null)
				{
					MOMO_PHONE_NUMBER = item.Attributes["MOMO_PHONE_NUMBER"].Value.ToString();
				}
			}
		}

		public static void Clear()
		{
			Servers = new Dictionary<int, ServerListInfo>();
			ExitServerPlay = new List<ServerListInfo>();
		}

		private static ServerListInfo DecodeServerListInfo(XmlNode xmlNode)
		{
			return XmlUtil.Deserialize<ServerListInfo>(XmlUtil.XmlNodeToString(xmlNode));
		}

		private static SlideInfo DecodeSlideInfo(XmlNode xmlNode_0)
		{
			return XmlUtil.Deserialize<SlideInfo>(XmlUtil.XmlNodeToString(xmlNode_0));
		}

		public static List<ServerListInfo> GetAllExitPlay()
		{
			return ExitServerPlay;
		}

		public static List<ServerListInfo> GetAllServerList()
		{
			return Servers.Values.ToList();
		}

		public static ServerListInfo FindServer(int id)
		{
			if (Servers.ContainsKey(id))
			{
				return Servers[id];
			}
			return null;
		}

		public static ServerListInfo FindExitServerByName(string name)
		{
			foreach (ServerListInfo item in ExitServerPlay)
			{
				if (item.ID.ToString().ToLower() == name.ToLower())
				{
					return item;
				}
			}
			return null;
		}

		public static ServerListInfo FindServerByName(string name)
		{
			foreach (ServerListInfo value in Servers.Values)
			{
				if (value.ID.ToString().ToLower() == name.ToLower())
				{
					return value;
				}
			}
			return null;
		}

		static ServerConfig()
		{
			Servers = new Dictionary<int, ServerListInfo>();
			Slides = new Dictionary<string, SlideInfo>();
			Version = "1.0.0.1";
			SiteName = "7Road";
			PlayMode = "OCX";
		}
	}
}
