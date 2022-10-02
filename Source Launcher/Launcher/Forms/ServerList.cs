using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;
using Launcher.Properties;
using Launcher.Statics;
using Microsoft.Win32;
using Properties;

namespace Launcher.Forms
{
	public class ServerList : Form
	{
		private int int_0;

		private readonly Main main_0 = Main.Instance;

		private bool bool_0;

		private IContainer icontainer_0;

		private Panel panelContent;

		private Panel panelRight;

		private Panel panelAllServer;

		private Panel panelExitPlay;

		internal static ServerList uXXpGGQbRsobOBoxYdN;

		public ServerList()
		{
			InitializeComponent();
			panelRight.Width = main_0.FixScaling(600);
			panelRight.Left = main_0.FixScaling(400);
			panelExitPlay.Width = main_0.FixScaling(520);
			panelExitPlay.Top = main_0.FixScaling(140);
			panelExitPlay.Left = main_0.FixScaling(70);
			panelAllServer.Width = main_0.FixScaling(520);
			panelAllServer.Top = main_0.FixScaling(270);
			panelAllServer.Left = main_0.FixScaling(70);
			method_1();
			method_2();
		}

		private void ServerList_Load(object sender, EventArgs e)
		{
			bool_0 = false;
			try
			{
				Registry.ClassesRoot.OpenSubKey("CLSID", writable: true);
			}
			catch
			{
				bool_0 = true;
			}
		}

		private PictureBox method_0(int int_1, Image image_0, string string_0, int int_2, int int_3)
		{
			PictureBox pictureBox = new PictureBox();
			pictureBox.Image = image_0;
			pictureBox.SizeMode = PictureBoxSizeMode.StretchImage;
			pictureBox.Cursor = Cursors.Hand;
			pictureBox.Location = new Point(int_2, int_3);
			pictureBox.Name = $"picBtn{string_0}Server_{int_1}";
			pictureBox.Size = new Size(main_0.FixScaling(200), main_0.FixScaling(40));
			pictureBox.Anchor = AnchorStyles.Top | AnchorStyles.Left;
			pictureBox.Dock = DockStyle.None;
			pictureBox.TabIndex = int_0;
			pictureBox.TabStop = false;
			pictureBox.MouseLeave += method_4;
			pictureBox.MouseHover += method_3;
			pictureBox.Click += method_5;
			int_0++;
			return pictureBox;
		}

		private void method_1()
		{
			List<ServerListInfo> allExitPlay = ServerConfig.GetAllExitPlay();
			int num = main_0.FixScaling(5);
			int num2 = main_0.FixScaling(5);
			int num3 = main_0.FixScaling(230);
			for (int i = 0; i < allExitPlay.Count; i++)
			{
				if (i % 2 != 0)
				{
					num += num3;
					panelExitPlay.Controls.Add(method_0(allExitPlay[i].ID, allExitPlay[i].ImgeLeave, "Exit", num, num2));
					continue;
				}
				num = ((i % 2 != 0) ? (num + num3) : 0);
				if (i > 0)
				{
					num2 += main_0.FixScaling(50);
				}
				panelExitPlay.Controls.Add(method_0(allExitPlay[i].ID, allExitPlay[i].ImgeLeave, "Exit", num, num2));
			}
		}

		private void method_2()
		{
			List<ServerListInfo> allServerList = ServerConfig.GetAllServerList();
			int num = main_0.FixScaling(7);
			int num2 = main_0.FixScaling(7);
			int num3 = main_0.FixScaling(230);
			for (int i = 0; i < allServerList.Count; i++)
			{
				if (i % 2 == 0)
				{
					num = ((i % 2 != 0) ? (num + num3) : 0);
					if (i > 0)
					{
						num2 += main_0.FixScaling(50);
					}
					panelAllServer.Controls.Add(method_0(allServerList[i].ID, allServerList[i].ImgeLeave, "Old", num, num2));
				}
				else
				{
					num += num3;
					panelAllServer.Controls.Add(method_0(allServerList[i].ID, allServerList[i].ImgeLeave, "Old", num, num2));
				}
			}
		}

		private void method_3(object sender, EventArgs e)
		{
			if (!(sender is PictureBox))
			{
				return;
			}
			string text = "-1";
			ServerListInfo serverListInfo = null;
			if ((sender as PictureBox).Name.IndexOf("_") != -1)
			{
				text = (sender as PictureBox).Name.Split('_')[1];
				string obj = (sender as PictureBox).Name.Split('_')[0];
				serverListInfo = ServerConfig.FindServerByName(text);
				if (obj == "picBtnExitServer")
				{
					serverListInfo = ServerConfig.FindExitServerByName(text);
				}
				if (serverListInfo != null)
				{
					(sender as PictureBox).Image = serverListInfo.ImgeHover;
				}
			}
		}

		private void method_4(object sender, EventArgs e)
		{
			if (!(sender is PictureBox))
			{
				return;
			}
			string text = "-1";
			ServerListInfo serverListInfo = null;
			if ((sender as PictureBox).Name.IndexOf("_") != -1)
			{
				text = (sender as PictureBox).Name.Split('_')[1];
				string obj = (sender as PictureBox).Name.Split('_')[0];
				serverListInfo = ServerConfig.FindServerByName(text);
				if (obj == "picBtnExitServer")
				{
					serverListInfo = ServerConfig.FindExitServerByName(text);
				}
				if (serverListInfo != null)
				{
					(sender as PictureBox).Image = serverListInfo.ImgeLeave;
				}
			}
		}

		private void method_5(object sender, EventArgs e)
		{
			if (!(sender is PictureBox))
			{
				return;
			}
			string text = "-1";
			ServerListInfo serverListInfo = null;
			if ((sender as PictureBox).Name.IndexOf("_") != -1)
			{
				text = (sender as PictureBox).Name.Split('_')[1];
				string obj = (sender as PictureBox).Name.Split('_')[0];
				serverListInfo = ServerConfig.FindServerByName(text);
				if (obj == "picBtnExitServer")
				{
					serverListInfo = ServerConfig.FindExitServerByName(text);
				}
			}
			if (serverListInfo != null)
			{
				DDTStaticFunc.ServerName = serverListInfo.Name;
				NameValueCollection param = new NameValueCollection
				{
					{
						"u",
						LoginMgr.Username
					},
					{
						"p",
						LoginMgr.Password
					},
					{
						"srv",
						serverListInfo.ID.ToString()
					},
					{
						"key",
						Util.MD5(LoginMgr.Username + LoginMgr.Password + Resources.PublicKey)
					}
				};
				string text2 = ControlMgr.Post(DDTStaticFunc.Host + Resources.PlayGame, param);
				if (text2.StartsWith("http"))
				{
					try
					{
						string[] array = text2.Split('?');
						DDTStaticFunc.Url = array[0];
						string text3 = array[1];
						if (array.Length == 3)
						{
							text3 = text3 + "&enterCode=" + Util.MD5(Resources.PublicKey + array[2]);
						}
						DDTStaticFunc.FlashVars = text3;
						main_0.OpenFormOnPanel<PlayGameInBox>();
					}
					catch (Exception)
					{
						Main.Instance.ChangePlayMode();
					}
				}
				else if (text2.StartsWith("System."))
				{
					MessageBox.Show("Kết nối máy chủ thất bại, vui lòng kiễm tra lại kết nối internet!");
				}
				else
				{
					MessageBox.Show(text2 + LoginMgr.Password);
				}
			}
			else
			{
				DDTStaticFunc.AddUpdateLogs("Can not find server", "Server Name:" + text);
			}
		}

		protected override void Dispose(bool disposing)
		{
			if (disposing && icontainer_0 != null)
			{
				icontainer_0.Dispose();
			}
			base.Dispose(disposing);
		}

		private void InitializeComponent()
		{
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Launcher.Forms.ServerList));
			panelContent = new System.Windows.Forms.Panel();
			panelRight = new System.Windows.Forms.Panel();
			panelAllServer = new System.Windows.Forms.Panel();
			panelExitPlay = new System.Windows.Forms.Panel();
			panelContent.SuspendLayout();
			panelRight.SuspendLayout();
			SuspendLayout();
			panelContent.BackgroundImage = Resources.serverlist;
			panelContent.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			panelContent.Controls.Add(panelRight);
			panelContent.Dock = System.Windows.Forms.DockStyle.Fill;
			panelContent.Location = new System.Drawing.Point(0, 0);
			panelContent.Name = "panelContent";
			panelContent.Size = new System.Drawing.Size(1000, 635);
			panelContent.TabIndex = 2;
			panelRight.BackColor = System.Drawing.Color.Transparent;
			panelRight.Controls.Add(panelAllServer);
			panelRight.Controls.Add(panelExitPlay);
			panelRight.Dock = System.Windows.Forms.DockStyle.Right;
			panelRight.Location = new System.Drawing.Point(400, 0);
			panelRight.Name = "panelRight";
			panelRight.Size = new System.Drawing.Size(600, 635);
			panelRight.TabIndex = 1;
			panelAllServer.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right;
			panelAllServer.BackColor = System.Drawing.Color.Transparent;
			panelAllServer.Location = new System.Drawing.Point(70, 270);
			panelAllServer.Margin = new System.Windows.Forms.Padding(1);
			panelAllServer.Name = "panelAllServer";
			panelAllServer.Size = new System.Drawing.Size(520, 350);
			panelAllServer.TabIndex = 1;
			panelExitPlay.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right;
			panelExitPlay.BackColor = System.Drawing.Color.Transparent;
			panelExitPlay.Location = new System.Drawing.Point(70, 140);
			panelExitPlay.Margin = new System.Windows.Forms.Padding(1);
			panelExitPlay.Name = "panelExitPlay";
			panelExitPlay.Size = new System.Drawing.Size(520, 90);
			panelExitPlay.TabIndex = 2;
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackgroundImage = Resources.serverlist;
			BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			base.ClientSize = new System.Drawing.Size(1000, 635);
			base.Controls.Add(panelContent);
			base.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
			base.Icon = (System.Drawing.Icon)resources.GetObject("$this.Icon");
			base.Name = "ServerList";
			base.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
			Text = "ServerList";
			base.Load += new System.EventHandler(ServerList_Load);
			panelContent.ResumeLayout(false);
			panelRight.ResumeLayout(false);
			ResumeLayout(false);
		}

		internal static void AujkSFQJDwrCZcTa9V9()
		{
		}

		internal static void EytVh2QY9b9FYQ4j6Ch()
		{
		}

		internal static bool VlpEVoQ5mpZGS9k1w2g()
		{
			return uXXpGGQbRsobOBoxYdN == null;
		}

		internal static void vml6PAcMo8tPxVFJZSB()
		{
		}
	}
}
