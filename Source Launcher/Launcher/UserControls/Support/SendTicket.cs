using System;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace Launcher.UserControls.Support
{
	public class SendTicket : UserControl
	{
		private IContainer icontainer_0;

		internal static SendTicket lvRX2ZhE37grH0nE0Iv;

		public SendTicket()
		{
			InitializeComponent();
		}

		private void SendTicket_Load(object sender, EventArgs e)
		{
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
			SuspendLayout();
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.White;
			base.Name = "SendTicket";
			base.Size = new System.Drawing.Size(1000, 595);
			base.Load += new System.EventHandler(SendTicket_Load);
			ResumeLayout(false);
		}

		internal static void H5cGdyhDEyNQ20fuKTS()
		{
		}

		internal static void HucbYRhipJIBXqZEL5W()
		{
		}

		internal static bool EqirB3hHNjR9CS3mt63()
		{
			return lvRX2ZhE37grH0nE0Iv == null;
		}
	}
}
