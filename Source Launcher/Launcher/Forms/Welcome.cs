using System;
using System.ComponentModel;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Windows.Forms;
using CircularProgressBar;
using Launcher.Popup;
using Launcher.Properties;
using Launcher.Statics;
using Properties;
using WinFormAnimation;
using Timer = System.Windows.Forms.Timer;

namespace Launcher.Forms
{
	public class Welcome : Form
	{
		private int int_0;

		private BackgroundWorker backgroundWorker_0;

		private string string_0 = Assembly.GetExecutingAssembly().GetName().Version.ToString();

		private int int_1 = 1;

		private int int_2 = 100;

		private IContainer icontainer_0;

		private Panel panelHeader;

		private PictureBox picBoxLogo;

		private Label lbTitle;

		private Label lbWelcome;

		private CircularProgressBar.CircularProgressBar YshfQdabJf;

		private Timer timer_0;

		private Timer timer_1;

		private PictureBox picBoxRate;

		private PictureBox picBox7roadLogo;

		private PictureBox nUufAoKaUY;

		private Timer timer_2;
        private IContainer components;
        private Label lbSiteName;
        private static Welcome xvlLkOl6VNaQuDfYRxR;

		public Welcome()
		{
			InitializeComponent();
			backgroundWorker_0 = new BackgroundWorker
			{
				WorkerReportsProgress = true,
				WorkerSupportsCancellation = true
			};
			backgroundWorker_0.DoWork += backgroundWorker_0_DoWork;
			backgroundWorker_0.RunWorkerCompleted += backgroundWorker_0_RunWorkerCompleted;
			backgroundWorker_0.ProgressChanged += backgroundWorker_0_ProgressChanged;
			int_0++;
		}

		private void Welcome_Load(object sender, EventArgs e)
		{
			lbSiteName.Text = ServerConfig.SiteName.ToUpper();
			int num = (base.Size.Width - lbSiteName.Width) / 2;
			int num2 = lbSiteName.Location.Y;
			lbSiteName.Location = new Point(num + 77, num2);
			num = (base.Size.Width - lbWelcome.Width) / 2;
			num2 = lbWelcome.Location.Y;
			lbWelcome.Location = new Point(num + 77, num2);
			num = (base.Size.Width - ((Control)(object)YshfQdabJf).Width) / 2;
			num2 = ((Control)(object)YshfQdabJf).Location.Y;
			((Control)(object)YshfQdabJf).Location = new Point(num + 77, num2);
			base.Opacity = 0.0;
			((ProgressBar)(object)YshfQdabJf).Value = 0;
			((ProgressBar)(object)YshfQdabJf).Minimum = 0;
			((ProgressBar)(object)YshfQdabJf).Maximum = 100;
			timer_0.Start();
		}

		private static void createFromResource(string startupPath, string filePath, string resourceName)
		{
			string path = startupPath + "\\" + filePath;
			using Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream((resourceName ?? ""));
			using BinaryReader binaryReader = new BinaryReader(stream);
			using FileStream output = new FileStream(path, FileMode.Create);
			using BinaryWriter binaryWriter = new BinaryWriter(output);
			binaryWriter.Write(binaryReader.ReadBytes((int)stream.Length));
		}

		private void backgroundWorker_0_DoWork(object sender, DoWorkEventArgs e)
		{
			string startupPath = Application.StartupPath;
			if (!Directory.Exists(startupPath))
			{
				Directory.CreateDirectory(startupPath);
			}
			createFromResource(startupPath, "runtime.dll", "Launcher.FlashSettings.runtime.dll");
			FileInfo fileInfo = new FileInfo(startupPath + "\\runtime.dll");
			if (fileInfo.Exists)
			{
				fileInfo.Attributes |= FileAttributes.Hidden;
			}
			string text = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + Resources.FlashSettings;
			if (!Directory.Exists(text))
			{
				Directory.CreateDirectory(text);
			}
			createFromResource(text, "settings.sol", "Launcher.FlashSettings.settings.sol");
			startupPath = text + "\\#ddt.trminhpc.com";
			if (!Directory.Exists(startupPath))
			{
				Directory.CreateDirectory(startupPath);
			}
			createFromResource(startupPath, "settings.sol", "Launcher.FlashSettings.ddt.trminhpc.com.settings.sol");
			startupPath = text + "\\#res.trminhpc.com";
			if (!Directory.Exists(startupPath))
			{
				Directory.CreateDirectory(startupPath);
			}
			createFromResource(startupPath, "settings.sol", "Launcher.FlashSettings.res.trminhpc.com.settings.sol");
			startupPath = text + "\\#q.gun321.com";
			if (!Directory.Exists(startupPath))
			{
				Directory.CreateDirectory(startupPath);
			}
			createFromResource(startupPath, "settings.sol", "Launcher.FlashSettings.q.gun321.com.settings.sol");
			startupPath = text + "\\#q.gun321.xyz";
			if (!Directory.Exists(startupPath))
			{
				Directory.CreateDirectory(startupPath);
			}
			createFromResource(startupPath, "settings.sol", "Launcher.FlashSettings.q.gun321.xyz.settings.sol");
			startupPath = text + "\\#vdc.gun321.com";
			if (!Directory.Exists(startupPath))
			{
				Directory.CreateDirectory(startupPath);
			}
			createFromResource(startupPath, "settings.sol", "Launcher.FlashSettings.vdc.gun321.com.settings.sol");
		}

		private void backgroundWorker_0_ProgressChanged(object sender, ProgressChangedEventArgs e)
		{
		}

		private void backgroundWorker_0_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
		{
			base.Opacity += 0.05;
			int_1 = 5;
		}

		private bool compareVersion()
		{
			string[] array = ServerConfig.Version.Split('.');
			string[] array2 = string_0.Split('.');
			int num = 0;
			int num2 = 0;
			string[] array3 = array;
			foreach (string s in array3)
			{
				num += int.Parse(s);
			}
			array3 = array2;
			foreach (string s2 in array3)
			{
				num2 += int.Parse(s2);
			}
			return num > num2;
		}

		private void timer_0_Tick(object sender, EventArgs e)
		{
			if (base.Opacity < 1.0)
			{
				base.Opacity += 0.05;
			}
			if (((ProgressBar)(object)YshfQdabJf).Value < 14)
			{
				((ProgressBar)(object)YshfQdabJf).Value += 2;
				((Control)(object)YshfQdabJf).Text = ((ProgressBar)(object)YshfQdabJf).Value.ToString();
			}
			if (((ProgressBar)(object)YshfQdabJf).Value == 14)
			{
				timer_0.Stop();
				if (compareVersion())
				{
					Hide();
					new UpdateNoitice().ShowDialog();
				}
				else
				{
					int_1 = 1;
					timer_2.Start();
					backgroundWorker_0.RunWorkerAsync();
				}
			}
		}

		private void timer_1_Tick(object sender, EventArgs e)
		{
			base.Opacity -= 0.1;
			if (base.Opacity == 0.0)
			{
				timer_1.Stop();
				Close();
			}
		}

		private void timer_2_Tick(object sender, EventArgs e)
		{
			if (base.Opacity < 1.0)
			{
				base.Opacity += 0.05;
			}
			if (((ProgressBar)(object)YshfQdabJf).Value + int_1 > int_2)
			{
				((ProgressBar)(object)YshfQdabJf).Value = int_2;
			}
			else
			{
				((ProgressBar)(object)YshfQdabJf).Value += int_1;
			}
			((Control)(object)YshfQdabJf).Text = ((ProgressBar)(object)YshfQdabJf).Value.ToString();
			if (((ProgressBar)(object)YshfQdabJf).Value >= int_2)
			{
				timer_2.Stop();
				timer_1.Start();
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Welcome));
            this.panelHeader = new System.Windows.Forms.Panel();
            this.picBoxRate = new System.Windows.Forms.PictureBox();
            this.lbTitle = new System.Windows.Forms.Label();
            this.picBoxLogo = new System.Windows.Forms.PictureBox();
            this.lbWelcome = new System.Windows.Forms.Label();
            this.YshfQdabJf = new CircularProgressBar.CircularProgressBar();
            this.timer_0 = new System.Windows.Forms.Timer(this.components);
            this.timer_1 = new System.Windows.Forms.Timer(this.components);
            this.picBox7roadLogo = new System.Windows.Forms.PictureBox();
            this.nUufAoKaUY = new System.Windows.Forms.PictureBox();
            this.timer_2 = new System.Windows.Forms.Timer(this.components);
            this.lbSiteName = new System.Windows.Forms.Label();
            this.panelHeader.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxRate)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLogo)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBox7roadLogo)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.nUufAoKaUY)).BeginInit();
            this.SuspendLayout();
            // 
            // panelHeader
            // 
            this.panelHeader.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(236)))), ((int)(((byte)(191)))), ((int)(((byte)(88)))));
            this.panelHeader.Controls.Add(this.picBoxRate);
            this.panelHeader.Controls.Add(this.lbTitle);
            this.panelHeader.Controls.Add(this.picBoxLogo);
            this.panelHeader.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelHeader.Location = new System.Drawing.Point(0, 0);
            this.panelHeader.Name = "panelHeader";
            this.panelHeader.Size = new System.Drawing.Size(1000, 100);
            this.panelHeader.TabIndex = 0;
            // 
            // picBoxRate
            // 
            this.picBoxRate.Image = global::Properties.Resources.type;
            this.picBoxRate.Location = new System.Drawing.Point(855, 12);
            this.picBoxRate.Name = "picBoxRate";
            this.picBoxRate.Size = new System.Drawing.Size(133, 77);
            this.picBoxRate.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxRate.TabIndex = 2;
            this.picBoxRate.TabStop = false;
            // 
            // lbTitle
            // 
            this.lbTitle.AutoSize = true;
            this.lbTitle.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(236)))), ((int)(((byte)(191)))), ((int)(((byte)(88)))));
            this.lbTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 21.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbTitle.ForeColor = System.Drawing.Color.White;
            this.lbTitle.Location = new System.Drawing.Point(103, 33);
            this.lbTitle.Name = "lbTitle";
            this.lbTitle.Size = new System.Drawing.Size(352, 33);
            this.lbTitle.TabIndex = 1;
            this.lbTitle.Text = "Game Bắn Súng Tọa Độ";
            // 
            // picBoxLogo
            // 
            this.picBoxLogo.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(236)))), ((int)(((byte)(191)))), ((int)(((byte)(88)))));
            this.picBoxLogo.Dock = System.Windows.Forms.DockStyle.Left;
            this.picBoxLogo.Image = global::Properties.Resources.alpha;
            this.picBoxLogo.Location = new System.Drawing.Point(0, 0);
            this.picBoxLogo.Name = "picBoxLogo";
            this.picBoxLogo.Size = new System.Drawing.Size(100, 100);
            this.picBoxLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxLogo.TabIndex = 0;
            this.picBoxLogo.TabStop = false;
            // 
            // lbWelcome
            // 
            this.lbWelcome.AutoSize = true;
            this.lbWelcome.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(216)))), ((int)(((byte)(74)))), ((int)(((byte)(73)))));
            this.lbWelcome.Font = new System.Drawing.Font("Microsoft Sans Serif", 48F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbWelcome.Location = new System.Drawing.Point(342, 103);
            this.lbWelcome.Name = "lbWelcome";
            this.lbWelcome.Size = new System.Drawing.Size(370, 73);
            this.lbWelcome.TabIndex = 2;
            this.lbWelcome.Text = "WELCOME";
            // 
            // YshfQdabJf
            // 
            this.YshfQdabJf.AnimationFunction = WinFormAnimation.KnownAnimationFunctions.Liner;
            this.YshfQdabJf.AnimationSpeed = 500;
            this.YshfQdabJf.BackColor = System.Drawing.Color.Transparent;
            this.YshfQdabJf.Font = new System.Drawing.Font("Microsoft Sans Serif", 30F, System.Drawing.FontStyle.Bold);
            this.YshfQdabJf.ForeColor = System.Drawing.Color.Silver;
            this.YshfQdabJf.InnerColor = System.Drawing.Color.FromArgb(((int)(((byte)(23)))), ((int)(((byte)(35)))), ((int)(((byte)(49)))));
            this.YshfQdabJf.InnerMargin = 2;
            this.YshfQdabJf.InnerWidth = -1;
            this.YshfQdabJf.Location = new System.Drawing.Point(443, 282);
            this.YshfQdabJf.MarqueeAnimationSpeed = 2000;
            this.YshfQdabJf.Name = "YshfQdabJf";
            this.YshfQdabJf.OuterColor = System.Drawing.Color.FromArgb(((int)(((byte)(112)))), ((int)(((byte)(178)))), ((int)(((byte)(200)))));
            this.YshfQdabJf.OuterMargin = -25;
            this.YshfQdabJf.OuterWidth = 26;
            this.YshfQdabJf.ProgressColor = System.Drawing.Color.FromArgb(((int)(((byte)(236)))), ((int)(((byte)(191)))), ((int)(((byte)(88)))));
            this.YshfQdabJf.ProgressWidth = 25;
            this.YshfQdabJf.SecondaryFont = new System.Drawing.Font("Microsoft Sans Serif", 18F);
            this.YshfQdabJf.Size = new System.Drawing.Size(150, 150);
            this.YshfQdabJf.StartAngle = 270;
            this.YshfQdabJf.Style = System.Windows.Forms.ProgressBarStyle.Marquee;
            this.YshfQdabJf.SubscriptColor = System.Drawing.Color.FromArgb(((int)(((byte)(166)))), ((int)(((byte)(166)))), ((int)(((byte)(166)))));
            this.YshfQdabJf.SubscriptMargin = new System.Windows.Forms.Padding(10, -35, 0, 0);
            this.YshfQdabJf.SubscriptText = "";
            this.YshfQdabJf.SuperscriptColor = System.Drawing.Color.FromArgb(((int)(((byte)(166)))), ((int)(((byte)(166)))), ((int)(((byte)(166)))));
            this.YshfQdabJf.SuperscriptMargin = new System.Windows.Forms.Padding(10, 35, 0, 0);
            this.YshfQdabJf.SuperscriptText = "%";
            this.YshfQdabJf.TabIndex = 5;
            this.YshfQdabJf.Text = "0";
            this.YshfQdabJf.TextMargin = new System.Windows.Forms.Padding(8, 8, 0, 0);
            this.YshfQdabJf.Value = 73;
            // 
            // timer_0
            // 
            this.timer_0.Tick += new System.EventHandler(this.timer_0_Tick);
            // 
            // timer_1
            // 
            this.timer_1.Tick += new System.EventHandler(this.timer_1_Tick);
            // 
            // picBox7roadLogo
            // 
            this.picBox7roadLogo.Image = global::Properties.Resources.logo7road;
            this.picBox7roadLogo.Location = new System.Drawing.Point(909, 458);
            this.picBox7roadLogo.Name = "picBox7roadLogo";
            this.picBox7roadLogo.Size = new System.Drawing.Size(79, 30);
            this.picBox7roadLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBox7roadLogo.TabIndex = 6;
            this.picBox7roadLogo.TabStop = false;
            // 
            // nUufAoKaUY
            // 
            this.nUufAoKaUY.Image = global::Properties.Resources.logoDDT;
            this.nUufAoKaUY.Location = new System.Drawing.Point(838, 458);
            this.nUufAoKaUY.Name = "nUufAoKaUY";
            this.nUufAoKaUY.Size = new System.Drawing.Size(65, 30);
            this.nUufAoKaUY.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.nUufAoKaUY.TabIndex = 6;
            this.nUufAoKaUY.TabStop = false;
            // 
            // timer_2
            // 
            this.timer_2.Tick += new System.EventHandler(this.timer_2_Tick);
            // 
            // lbSiteName
            // 
            this.lbSiteName.AutoSize = true;
            this.lbSiteName.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(239)))), ((int)(((byte)(175)))), ((int)(((byte)(69)))));
            this.lbSiteName.Font = new System.Drawing.Font("Microsoft Sans Serif", 21.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbSiteName.ForeColor = System.Drawing.Color.White;
            this.lbSiteName.Location = new System.Drawing.Point(377, 458);
            this.lbSiteName.Name = "lbSiteName";
            this.lbSiteName.Size = new System.Drawing.Size(305, 33);
            this.lbSiteName.TabIndex = 3;
            this.lbSiteName.Text = "DDTank Gunny 2021";
            // 
            // Welcome
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(227)))), ((int)(((byte)(175)))));
            this.ClientSize = new System.Drawing.Size(1000, 500);
            this.Controls.Add(this.nUufAoKaUY);
            this.Controls.Add(this.picBox7roadLogo);
            this.Controls.Add(this.YshfQdabJf);
            this.Controls.Add(this.lbSiteName);
            this.Controls.Add(this.lbWelcome);
            this.Controls.Add(this.panelHeader);
            this.ForeColor = System.Drawing.Color.White;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Welcome";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Welcome";
            this.Load += new System.EventHandler(this.Welcome_Load);
            this.panelHeader.ResumeLayout(false);
            this.panelHeader.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxRate)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxLogo)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBox7roadLogo)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.nUufAoKaUY)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		internal static void eDPr4mleChB84nn0rgt()
		{
		}

		internal static void ko1q9clMUUdtEliFUto()
		{
		}

		internal static bool zB3JSYlLZGitSyiybGs()
		{
			return xvlLkOl6VNaQuDfYRxR == null;
		}

		internal static void uOT9WrSvbWcBLqKqK18()
		{
		}
	}
}
