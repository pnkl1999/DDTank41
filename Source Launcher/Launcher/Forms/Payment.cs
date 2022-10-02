using System;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using Launcher.UserControls;

namespace Launcher.Forms
{
    public class Payment : Form
    {
        private readonly Main main_0 = Main.Instance;

        private IContainer icontainer_0;

        private Panel panelPayTop;

        private Label labelExchange;

        private Label labelTopup;

        private Panel panelSlide;

        private Panel panelContent;

        private Label labelHistoryTopup;
        private Label labelPaymentMomo;
        private static Payment mvBHvGOuUpbkYNS58jF;

        public Payment()
        {
            InitializeComponent();
            labelTopup.Visible = false;
        }

        public void OpenUserControlOnPanel<UForm>() where UForm : UserControl, new()
        {
            UserControl userControl = panelContent.Controls.OfType<UForm>().FirstOrDefault();
            if (userControl == null)
            {
                userControl = new UForm
                {
                    Dock = DockStyle.Fill
                };
                panelContent.Controls.Add(userControl);
                panelContent.Tag = userControl;
                userControl.Show();
                userControl.BringToFront();
                userControl.Focus();
            }
            else
            {
                userControl.BringToFront();
                userControl.Focus();
            }
        }

        private void Payment_Load(object sender, EventArgs e)
        {
            //OpenUserControlOnPanel<TopUp>();
            OpenUserControlOnPanel<Exchange>();
            labelTopup.ForeColor = Color.FromArgb(105, 224, 255);
        }

        private void labelHistoryTopup_Click(object sender, EventArgs e)
        {
            if (sender is Label)
            {
                panelSlide.Left = (sender as Label).Left;
                panelSlide.Width = (sender as Label).Width;
                switch ((sender as Label).Name)
                {
                    case "labelExchange":
                        OpenUserControlOnPanel<Exchange>();
                        break;
                    case "labelHistoryTopup":
                        OpenUserControlOnPanel<HistoryTopUp>();
                        break;
                    //case "labelTopup":
                    //    OpenUserControlOnPanel<TopUp>();
                    //    break;
                    case "labelPaymentMomo":
                        OpenUserControlOnPanel<PaymentMomo>();
                        break;
                }
                (sender as Label).ForeColor = Color.FromArgb(105, 224, 255);
            }
            foreach (object control in panelPayTop.Controls)
            {
                if (control is Label && (control as Label).Left != panelSlide.Left)
                {
                    (control as Label).ForeColor = Color.White;
                }
            }
        }

        private void labelHistoryTopup_MouseHover(object sender, EventArgs e)
        {
            if (sender is Label)
            {
                (sender as Label).ForeColor = Color.FromArgb(105, 224, 255);
            }
        }

        private void labelHistoryTopup_MouseLeave(object sender, EventArgs e)
        {
            if (sender is Label && (sender as Label).Left != panelSlide.Left)
            {
                (sender as Label).ForeColor = Color.White;
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
            this.panelPayTop = new System.Windows.Forms.Panel();
            this.labelPaymentMomo = new System.Windows.Forms.Label();
            this.labelHistoryTopup = new System.Windows.Forms.Label();
            this.labelExchange = new System.Windows.Forms.Label();
            this.labelTopup = new System.Windows.Forms.Label();
            this.panelSlide = new System.Windows.Forms.Panel();
            this.panelContent = new System.Windows.Forms.Panel();
            this.panelPayTop.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelPayTop
            // 
            this.panelPayTop.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(76)))), ((int)(((byte)(71)))), ((int)(((byte)(54)))));
            this.panelPayTop.Controls.Add(this.labelPaymentMomo);
            this.panelPayTop.Controls.Add(this.labelHistoryTopup);
            this.panelPayTop.Controls.Add(this.labelExchange);
            this.panelPayTop.Controls.Add(this.labelTopup);
            this.panelPayTop.Controls.Add(this.panelSlide);
            this.panelPayTop.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelPayTop.Location = new System.Drawing.Point(0, 0);
            this.panelPayTop.Name = "panelPayTop";
            this.panelPayTop.Size = new System.Drawing.Size(1000, 40);
            this.panelPayTop.TabIndex = 1;
            // 
            // labelPaymentMomo
            // 
            this.labelPaymentMomo.AutoSize = true;
            this.labelPaymentMomo.BackColor = System.Drawing.Color.Transparent;
            this.labelPaymentMomo.Cursor = System.Windows.Forms.Cursors.Hand;
            this.labelPaymentMomo.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelPaymentMomo.ForeColor = System.Drawing.Color.White;
            this.labelPaymentMomo.Location = new System.Drawing.Point(204, 10);
            this.labelPaymentMomo.Name = "labelPaymentMomo";
            this.labelPaymentMomo.Size = new System.Drawing.Size(81, 16);
            this.labelPaymentMomo.TabIndex = 4;
            this.labelPaymentMomo.Text = "NẠP MOMO";
            this.labelPaymentMomo.Click += new System.EventHandler(this.labelHistoryTopup_Click);
            this.labelPaymentMomo.MouseLeave += new System.EventHandler(this.labelHistoryTopup_MouseLeave);
            this.labelPaymentMomo.MouseHover += new System.EventHandler(this.labelHistoryTopup_MouseHover);
            // 
            // labelHistoryTopup
            // 
            this.labelHistoryTopup.AutoSize = true;
            this.labelHistoryTopup.BackColor = System.Drawing.Color.Transparent;
            this.labelHistoryTopup.Cursor = System.Windows.Forms.Cursors.Hand;
            this.labelHistoryTopup.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelHistoryTopup.ForeColor = System.Drawing.Color.White;
            this.labelHistoryTopup.Location = new System.Drawing.Point(302, 10);
            this.labelHistoryTopup.Name = "labelHistoryTopup";
            this.labelHistoryTopup.Size = new System.Drawing.Size(129, 16);
            this.labelHistoryTopup.TabIndex = 3;
            this.labelHistoryTopup.Text = "LỊCH SỬ GIAO DỊCH";
            this.labelHistoryTopup.Click += new System.EventHandler(this.labelHistoryTopup_Click);
            this.labelHistoryTopup.MouseLeave += new System.EventHandler(this.labelHistoryTopup_MouseLeave);
            this.labelHistoryTopup.MouseHover += new System.EventHandler(this.labelHistoryTopup_MouseHover);
            // 
            // labelExchange
            // 
            this.labelExchange.AutoSize = true;
            this.labelExchange.BackColor = System.Drawing.Color.Transparent;
            this.labelExchange.Cursor = System.Windows.Forms.Cursors.Hand;
            this.labelExchange.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelExchange.ForeColor = System.Drawing.Color.White;
            this.labelExchange.Location = new System.Drawing.Point(125, 10);
            this.labelExchange.Name = "labelExchange";
            this.labelExchange.Size = new System.Drawing.Size(51, 16);
            this.labelExchange.TabIndex = 3;
            this.labelExchange.Text = "ĐỔI XU";
            this.labelExchange.Click += new System.EventHandler(this.labelHistoryTopup_Click);
            this.labelExchange.MouseLeave += new System.EventHandler(this.labelHistoryTopup_MouseLeave);
            this.labelExchange.MouseHover += new System.EventHandler(this.labelHistoryTopup_MouseHover);
            // 
            // labelTopup
            // 
            this.labelTopup.AutoSize = true;
            this.labelTopup.BackColor = System.Drawing.Color.Transparent;
            this.labelTopup.Cursor = System.Windows.Forms.Cursors.Hand;
            this.labelTopup.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelTopup.ForeColor = System.Drawing.Color.White;
            this.labelTopup.Location = new System.Drawing.Point(25, 10);
            this.labelTopup.Name = "labelTopup";
            this.labelTopup.Size = new System.Drawing.Size(67, 16);
            this.labelTopup.TabIndex = 3;
            this.labelTopup.Text = "NẠP THẺ";
            this.labelTopup.Click += new System.EventHandler(this.labelHistoryTopup_Click);
            this.labelTopup.MouseLeave += new System.EventHandler(this.labelHistoryTopup_MouseLeave);
            this.labelTopup.MouseHover += new System.EventHandler(this.labelHistoryTopup_MouseHover);
            // 
            // panelSlide
            // 
            this.panelSlide.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(105)))), ((int)(((byte)(224)))), ((int)(((byte)(255)))));
            this.panelSlide.Location = new System.Drawing.Point(25, 35);
            this.panelSlide.Name = "panelSlide";
            this.panelSlide.Size = new System.Drawing.Size(67, 5);
            this.panelSlide.TabIndex = 2;
            this.panelSlide.Visible = false;
            // 
            // panelContent
            // 
            this.panelContent.BackColor = System.Drawing.Color.White;
            this.panelContent.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelContent.Location = new System.Drawing.Point(0, 40);
            this.panelContent.Name = "panelContent";
            this.panelContent.Size = new System.Drawing.Size(1000, 595);
            this.panelContent.TabIndex = 2;
            // 
            // Payment
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1000, 635);
            this.Controls.Add(this.panelContent);
            this.Controls.Add(this.panelPayTop);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Payment";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Payment";
            this.Load += new System.EventHandler(this.Payment_Load);
            this.panelPayTop.ResumeLayout(false);
            this.panelPayTop.PerformLayout();
            this.ResumeLayout(false);

        }

        internal static void GM9oikOWZgQSbkxrCwG()
        {
        }

        internal static void ImaMhUOXSAVyT4tDB9Z()
        {
        }

        internal static bool TdmkLuONXxZSjUdBkaS()
        {
            return mvBHvGOuUpbkYNS58jF == null;
        }

        internal static void r09IiMRr4a5bb1sUErr()
        {
        }
    }
}
