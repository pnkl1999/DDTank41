using System;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Windows.Forms;
using Bunifu.UI.WinForms;
using Bunifu.UI.WinForms.BunifuButton;
using Launcher.Models;
using Launcher.Properties;
using Launcher.Statics;
using Newtonsoft.Json;
using Properties;

namespace Launcher.UserControls
{
	public class HistoryTopUp : UserControl
	{
		private readonly Main main_0 = Main.Instance;

		private int int_0;

		private int int_1;

		private IContainer icontainer_0;

		private Panel panel1;

		private Label labelTotalRecords;

		private BunifuButton bunifuBtnGo;

		private BunifuButton bunifuBtnLastPage;

		private BunifuButton bunifuBtnNext;

		private BunifuButton bunifuBtnPrevious;

		private BunifuButton bunifuBtnFirstPage;

		private BunifuTextBox bunifuTxtCurentPage;

		private Panel panel3;

		private Label label1;

		private Panel panel2;

		private BunifuDataGridView dgvExchangeLog;

		private DataGridViewTextBoxColumn dgvExchangeLogID;

		private DataGridViewTextBoxColumn dgvExchangeLogNameCard;

		private DataGridViewTextBoxColumn dgvExchangeLogSerial;

		private DataGridViewTextBoxColumn dgvExchangeLogCodeCard;

		private DataGridViewTextBoxColumn dgvExchangeLogValueCard;

		private DataGridViewTextBoxColumn dgvExchangeLogStatus;

		private DataGridViewTextBoxColumn dgvExchangeLogTimeCreate;

		private BunifuTextBox bunifuTxtSearch;

		private PictureBox picBoxSearch;

		private Label lbPageCount;

		private static HistoryTopUp Is0gegmPon9hV6hXJ1o;

		public HistoryTopUp()
		{
			InitializeComponent();
			bunifuTxtSearch.Height = (picBoxSearch.Height = main_0.FixScaling(30));
		}

		private void loadHistoryTopup(string pageNumber = "1", string searchText = "")
		{
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
				{ "page", pageNumber },
				{ "key", searchText },
				{
					"privateKey",
					Util.MD5(LoginMgr.Username + LoginMgr.Password + Resources.PublicKey)
				}
			};
			string text = ControlMgr.Post(DDTStaticFunc.Host + Resources.ExchangeLog, param);
			try
			{
				JsonPaging jsonPaging = JsonConvert.DeserializeObject<JsonPaging>(text);
				dgvExchangeLog.AutoGenerateColumns = false;
				dgvExchangeLog.ColumnHeadersHeight = main_0.FixScaling(40);
				dgvExchangeLog.RowHeadersWidth = main_0.FixScaling(30);
				DataTable dataTable = jsonPaging.Data.Clone();
				//dataTable.Columns.Add("ValueCard", Type.GetType("System.String"));
				//dataTable.Columns.Add("Status", Type.GetType("System.String"));
				//dataTable.Columns["ValueCard"].DataType = System.Type.GetType("System.String");
				//dataTable.Columns["Status"].DataType = System.Type.GetType("System.String");
				foreach (DataRow row in jsonPaging.Data.Rows)﻿
				{
					dataTable.ImportRow(row);
				}
				foreach (DataRow row2 in dataTable.Rows)
				{
					row2["ValueCard"] = int.Parse(row2["ValueCard"].ToString()).ToString("n", CultureInfo.GetCultureInfo("vi-VN")).Replace(",00", "");
					switch (int.Parse(row2["Status"].ToString()))
					{
					case 0:
						row2["Status"] = "Đang xử lý";
						break;
					case 1:
						row2["Status"] = "Thành công";
						break;
					case 2:
						row2["Status"] = "Sai mệnh giá";
						break;
					case 3:
						row2["Status"] = "Sai thẻ";
						break;
					case 4:
						row2["Status"] = "Bảo trì";
						break;
					}
				}
				dgvExchangeLog.DataSource = dataTable;
				labelTotalRecords.Text = $"Tổng số: {jsonPaging.TotalRecord}";
				int_0 = jsonPaging.TotalRecord;
				int num = int_0 / 12;
				if (num * 12 < int_0)
				{
					int_1 = num + 1;
				}
				lbPageCount.Text = $"/ {int_1}";
			}
			catch (Exception ex)
			{
				DDTStaticFunc.AddUpdateLogs("Exception LoadExchangeLog " + ex.Message, $"result:{text},  \nerrors:{ex}");
			}
		}

		private void HistoryTopUp_Load(object sender, EventArgs e)
		{
		}

		private void HistoryTopUp_Enter(object sender, EventArgs e)
		{
			loadHistoryTopup();
			bunifuTxtCurentPage.Text = "1";
			Pagination();
		}

		private void Pagination()
		{
			if (!(bunifuTxtCurentPage.Text == "1"))
			{
				bunifuBtnPrevious.Enabled = true;
				bunifuBtnFirstPage.Enabled = true;
			}
			else
			{
				bunifuBtnPrevious.Enabled = false;
				bunifuBtnFirstPage.Enabled = false;
			}
			if (bunifuTxtCurentPage.Text == $"{int_1}")
			{
				bunifuBtnNext.Enabled = false;
				bunifuBtnLastPage.Enabled = false;
			}
			else
			{
				bunifuBtnNext.Enabled = true;
				bunifuBtnLastPage.Enabled = true;
			}
		}

		private void bunifuBtnGo_Click(object sender, EventArgs e)
		{
			loadHistoryTopup(bunifuTxtCurentPage.Text);
			Pagination();
		}

		private void bunifuTxtSearch_KeyUp(object sender, KeyEventArgs e)
		{
			loadHistoryTopup("1", bunifuTxtSearch.Text);
			Pagination();
		}

		private void bunifuTxtCurentPage_KeyUp(object sender, KeyEventArgs e)
		{
		}

		private void bunifuTxtCurentPage_TextChange(object sender, EventArgs e)
		{
			if (int.TryParse(bunifuTxtCurentPage.Text, out var result))
			{
				if (result > int_1)
				{
					result = int_1;
				}
				bunifuTxtCurentPage.Text = $"{result}";
			}
			else
			{
				bunifuTxtCurentPage.Text = "1";
			}
		}

		private void bunifuBtnFirstPage_Click(object sender, EventArgs e)
		{
			bunifuTxtCurentPage.Text = $"{1}";
			loadHistoryTopup(bunifuTxtCurentPage.Text);
			Pagination();
		}

		private void bunifuBtnPrevious_Click(object sender, EventArgs e)
		{
			if (int.TryParse(bunifuTxtCurentPage.Text, out var result))
			{
				if (result > 1)
				{
					result--;
				}
				bunifuTxtCurentPage.Text = $"{result}";
			}
			else
			{
				bunifuTxtCurentPage.Text = "1";
			}
			loadHistoryTopup(bunifuTxtCurentPage.Text);
			Pagination();
		}

		private void bunifuBtnNext_Click(object sender, EventArgs e)
		{
			if (int.TryParse(bunifuTxtCurentPage.Text, out var result))
			{
				if (result < int_1)
				{
					result++;
				}
				bunifuTxtCurentPage.Text = $"{result}";
			}
			else
			{
				bunifuTxtCurentPage.Text = "1";
			}
			loadHistoryTopup(bunifuTxtCurentPage.Text);
			Pagination();
		}

		private void bunifuBtnLastPage_Click(object sender, EventArgs e)
		{
			bunifuTxtCurentPage.Text = $"{int_1}";
			loadHistoryTopup(bunifuTxtCurentPage.Text);
			Pagination();
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
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Launcher.UserControls.HistoryTopUp));
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges2 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges3 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges4 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges borderEdges5 = new Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderEdges();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties2 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties3 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties4 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties5 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties6 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties7 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			Bunifu.UI.WinForms.BunifuTextBox.StateProperties stateProperties8 = new Bunifu.UI.WinForms.BunifuTextBox.StateProperties();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
			panel1 = new System.Windows.Forms.Panel();
			bunifuBtnGo = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			bunifuBtnLastPage = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			bunifuBtnNext = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			bunifuBtnPrevious = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			bunifuBtnFirstPage = new Bunifu.UI.WinForms.BunifuButton.BunifuButton();
			bunifuTxtCurentPage = new Bunifu.UI.WinForms.BunifuTextBox();
			lbPageCount = new System.Windows.Forms.Label();
			labelTotalRecords = new System.Windows.Forms.Label();
			panel3 = new System.Windows.Forms.Panel();
			label1 = new System.Windows.Forms.Label();
			panel2 = new System.Windows.Forms.Panel();
			picBoxSearch = new System.Windows.Forms.PictureBox();
			bunifuTxtSearch = new Bunifu.UI.WinForms.BunifuTextBox();
			dgvExchangeLog = new Bunifu.UI.WinForms.BunifuDataGridView();
			dgvExchangeLogID = new System.Windows.Forms.DataGridViewTextBoxColumn();
			dgvExchangeLogNameCard = new System.Windows.Forms.DataGridViewTextBoxColumn();
			dgvExchangeLogSerial = new System.Windows.Forms.DataGridViewTextBoxColumn();
			dgvExchangeLogCodeCard = new System.Windows.Forms.DataGridViewTextBoxColumn();
			dgvExchangeLogValueCard = new System.Windows.Forms.DataGridViewTextBoxColumn();
			dgvExchangeLogStatus = new System.Windows.Forms.DataGridViewTextBoxColumn();
			dgvExchangeLogTimeCreate = new System.Windows.Forms.DataGridViewTextBoxColumn();
			panel1.SuspendLayout();
			panel3.SuspendLayout();
			panel2.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)picBoxSearch).BeginInit();
			((System.ComponentModel.ISupportInitialize)dgvExchangeLog).BeginInit();
			SuspendLayout();
			panel1.BackColor = System.Drawing.Color.FromArgb(191, 214, 237);
			panel1.Controls.Add(bunifuBtnGo);
			panel1.Controls.Add(bunifuBtnLastPage);
			panel1.Controls.Add(bunifuBtnNext);
			panel1.Controls.Add(bunifuBtnPrevious);
			panel1.Controls.Add(bunifuBtnFirstPage);
			panel1.Controls.Add(bunifuTxtCurentPage);
			panel1.Controls.Add(lbPageCount);
			panel1.Controls.Add(labelTotalRecords);
			panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
			panel1.Location = new System.Drawing.Point(0, 550);
			panel1.Name = "panel1";
			panel1.Size = new System.Drawing.Size(1000, 45);
			panel1.TabIndex = 3;
			bunifuBtnGo.AllowToggling = false;
			bunifuBtnGo.AnimationSpeed = 200;
			bunifuBtnGo.AutoGenerateColors = false;
			bunifuBtnGo.AutoSizeLeftIcon = true;
			bunifuBtnGo.AutoSizeRightIcon = true;
			bunifuBtnGo.BackColor = System.Drawing.Color.Transparent;
			bunifuBtnGo.BackColor1 = System.Drawing.Color.DodgerBlue;
			bunifuBtnGo.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuBtnGo.BackgroundImage");
			bunifuBtnGo.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnGo.ButtonText = "Go";
			bunifuBtnGo.ButtonTextMarginLeft = 0;
			bunifuBtnGo.ColorContrastOnClick = 45;
			bunifuBtnGo.ColorContrastOnHover = 45;
			bunifuBtnGo.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges.BottomLeft = true;
			borderEdges.BottomRight = true;
			borderEdges.TopLeft = true;
			borderEdges.TopRight = true;
			bunifuBtnGo.CustomizableEdges = borderEdges;
			bunifuBtnGo.DialogResult = System.Windows.Forms.DialogResult.None;
			bunifuBtnGo.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnGo.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnGo.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnGo.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			bunifuBtnGo.Font = new System.Drawing.Font("Segoe UI", 9f);
			bunifuBtnGo.ForeColor = System.Drawing.Color.White;
			bunifuBtnGo.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			bunifuBtnGo.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnGo.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			bunifuBtnGo.IconMarginLeft = 11;
			bunifuBtnGo.IconPadding = 10;
			bunifuBtnGo.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			bunifuBtnGo.IconRightCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnGo.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			bunifuBtnGo.IconSize = 25;
			bunifuBtnGo.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnGo.IdleBorderRadius = 1;
			bunifuBtnGo.IdleBorderThickness = 1;
			bunifuBtnGo.IdleFillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnGo.IdleIconLeftImage = null;
			bunifuBtnGo.IdleIconRightImage = null;
			bunifuBtnGo.IndicateFocus = false;
			bunifuBtnGo.Location = new System.Drawing.Point(517, 10);
			bunifuBtnGo.Name = "bunifuBtnGo";
			bunifuBtnGo.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnGo.OnDisabledState.BorderRadius = 1;
			bunifuBtnGo.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnGo.OnDisabledState.BorderThickness = 1;
			bunifuBtnGo.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnGo.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnGo.OnDisabledState.IconLeftImage = null;
			bunifuBtnGo.OnDisabledState.IconRightImage = null;
			bunifuBtnGo.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnGo.onHoverState.BorderRadius = 1;
			bunifuBtnGo.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnGo.onHoverState.BorderThickness = 1;
			bunifuBtnGo.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnGo.onHoverState.ForeColor = System.Drawing.Color.White;
			bunifuBtnGo.onHoverState.IconLeftImage = null;
			bunifuBtnGo.onHoverState.IconRightImage = null;
			bunifuBtnGo.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnGo.OnIdleState.BorderRadius = 1;
			bunifuBtnGo.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnGo.OnIdleState.BorderThickness = 1;
			bunifuBtnGo.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnGo.OnIdleState.ForeColor = System.Drawing.Color.White;
			bunifuBtnGo.OnIdleState.IconLeftImage = null;
			bunifuBtnGo.OnIdleState.IconRightImage = null;
			bunifuBtnGo.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnGo.OnPressedState.BorderRadius = 1;
			bunifuBtnGo.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnGo.OnPressedState.BorderThickness = 1;
			bunifuBtnGo.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnGo.OnPressedState.ForeColor = System.Drawing.Color.White;
			bunifuBtnGo.OnPressedState.IconLeftImage = null;
			bunifuBtnGo.OnPressedState.IconRightImage = null;
			bunifuBtnGo.Size = new System.Drawing.Size(36, 25);
			bunifuBtnGo.TabIndex = 4;
			bunifuBtnGo.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			bunifuBtnGo.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			bunifuBtnGo.TextMarginLeft = 0;
			bunifuBtnGo.TextPadding = new System.Windows.Forms.Padding(0);
			bunifuBtnGo.UseDefaultRadiusAndThickness = true;
			bunifuBtnGo.Click += new System.EventHandler(bunifuBtnGo_Click);
			bunifuBtnLastPage.AllowToggling = false;
			bunifuBtnLastPage.AnimationSpeed = 200;
			bunifuBtnLastPage.AutoGenerateColors = false;
			bunifuBtnLastPage.AutoSizeLeftIcon = true;
			bunifuBtnLastPage.AutoSizeRightIcon = true;
			bunifuBtnLastPage.BackColor = System.Drawing.Color.Transparent;
			bunifuBtnLastPage.BackColor1 = System.Drawing.Color.DodgerBlue;
			bunifuBtnLastPage.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuBtnLastPage.BackgroundImage");
			bunifuBtnLastPage.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnLastPage.ButtonText = "Trang cuối";
			bunifuBtnLastPage.ButtonTextMarginLeft = 0;
			bunifuBtnLastPage.ColorContrastOnClick = 45;
			bunifuBtnLastPage.ColorContrastOnHover = 45;
			bunifuBtnLastPage.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges2.BottomLeft = true;
			borderEdges2.BottomRight = true;
			borderEdges2.TopLeft = true;
			borderEdges2.TopRight = true;
			bunifuBtnLastPage.CustomizableEdges = borderEdges2;
			bunifuBtnLastPage.DialogResult = System.Windows.Forms.DialogResult.None;
			bunifuBtnLastPage.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnLastPage.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnLastPage.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnLastPage.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			bunifuBtnLastPage.Font = new System.Drawing.Font("Segoe UI", 9f);
			bunifuBtnLastPage.ForeColor = System.Drawing.Color.White;
			bunifuBtnLastPage.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			bunifuBtnLastPage.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnLastPage.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			bunifuBtnLastPage.IconMarginLeft = 11;
			bunifuBtnLastPage.IconPadding = 10;
			bunifuBtnLastPage.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			bunifuBtnLastPage.IconRightCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnLastPage.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			bunifuBtnLastPage.IconSize = 25;
			bunifuBtnLastPage.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnLastPage.IdleBorderRadius = 1;
			bunifuBtnLastPage.IdleBorderThickness = 1;
			bunifuBtnLastPage.IdleFillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnLastPage.IdleIconLeftImage = null;
			bunifuBtnLastPage.IdleIconRightImage = null;
			bunifuBtnLastPage.IndicateFocus = false;
			bunifuBtnLastPage.Location = new System.Drawing.Point(736, 10);
			bunifuBtnLastPage.Name = "bunifuBtnLastPage";
			bunifuBtnLastPage.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnLastPage.OnDisabledState.BorderRadius = 1;
			bunifuBtnLastPage.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnLastPage.OnDisabledState.BorderThickness = 1;
			bunifuBtnLastPage.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnLastPage.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnLastPage.OnDisabledState.IconLeftImage = null;
			bunifuBtnLastPage.OnDisabledState.IconRightImage = null;
			bunifuBtnLastPage.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnLastPage.onHoverState.BorderRadius = 1;
			bunifuBtnLastPage.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnLastPage.onHoverState.BorderThickness = 1;
			bunifuBtnLastPage.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnLastPage.onHoverState.ForeColor = System.Drawing.Color.White;
			bunifuBtnLastPage.onHoverState.IconLeftImage = null;
			bunifuBtnLastPage.onHoverState.IconRightImage = null;
			bunifuBtnLastPage.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnLastPage.OnIdleState.BorderRadius = 1;
			bunifuBtnLastPage.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnLastPage.OnIdleState.BorderThickness = 1;
			bunifuBtnLastPage.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnLastPage.OnIdleState.ForeColor = System.Drawing.Color.White;
			bunifuBtnLastPage.OnIdleState.IconLeftImage = null;
			bunifuBtnLastPage.OnIdleState.IconRightImage = null;
			bunifuBtnLastPage.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnLastPage.OnPressedState.BorderRadius = 1;
			bunifuBtnLastPage.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnLastPage.OnPressedState.BorderThickness = 1;
			bunifuBtnLastPage.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnLastPage.OnPressedState.ForeColor = System.Drawing.Color.White;
			bunifuBtnLastPage.OnPressedState.IconLeftImage = null;
			bunifuBtnLastPage.OnPressedState.IconRightImage = null;
			bunifuBtnLastPage.Size = new System.Drawing.Size(92, 25);
			bunifuBtnLastPage.TabIndex = 5;
			bunifuBtnLastPage.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			bunifuBtnLastPage.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			bunifuBtnLastPage.TextMarginLeft = 0;
			bunifuBtnLastPage.TextPadding = new System.Windows.Forms.Padding(0);
			bunifuBtnLastPage.UseDefaultRadiusAndThickness = true;
			bunifuBtnLastPage.Click += new System.EventHandler(bunifuBtnLastPage_Click);
			bunifuBtnNext.AllowToggling = false;
			bunifuBtnNext.AnimationSpeed = 200;
			bunifuBtnNext.AutoGenerateColors = false;
			bunifuBtnNext.AutoSizeLeftIcon = true;
			bunifuBtnNext.AutoSizeRightIcon = true;
			bunifuBtnNext.BackColor = System.Drawing.Color.Transparent;
			bunifuBtnNext.BackColor1 = System.Drawing.Color.DodgerBlue;
			bunifuBtnNext.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuBtnNext.BackgroundImage");
			bunifuBtnNext.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnNext.ButtonText = "Trang sau";
			bunifuBtnNext.ButtonTextMarginLeft = 0;
			bunifuBtnNext.ColorContrastOnClick = 45;
			bunifuBtnNext.ColorContrastOnHover = 45;
			bunifuBtnNext.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges3.BottomLeft = true;
			borderEdges3.BottomRight = true;
			borderEdges3.TopLeft = true;
			borderEdges3.TopRight = true;
			bunifuBtnNext.CustomizableEdges = borderEdges3;
			bunifuBtnNext.DialogResult = System.Windows.Forms.DialogResult.None;
			bunifuBtnNext.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnNext.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnNext.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnNext.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			bunifuBtnNext.Font = new System.Drawing.Font("Segoe UI", 9f);
			bunifuBtnNext.ForeColor = System.Drawing.Color.White;
			bunifuBtnNext.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			bunifuBtnNext.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnNext.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			bunifuBtnNext.IconMarginLeft = 11;
			bunifuBtnNext.IconPadding = 10;
			bunifuBtnNext.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			bunifuBtnNext.IconRightCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnNext.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			bunifuBtnNext.IconSize = 25;
			bunifuBtnNext.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnNext.IdleBorderRadius = 1;
			bunifuBtnNext.IdleBorderThickness = 1;
			bunifuBtnNext.IdleFillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnNext.IdleIconLeftImage = null;
			bunifuBtnNext.IdleIconRightImage = null;
			bunifuBtnNext.IndicateFocus = false;
			bunifuBtnNext.Location = new System.Drawing.Point(638, 10);
			bunifuBtnNext.Name = "bunifuBtnNext";
			bunifuBtnNext.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnNext.OnDisabledState.BorderRadius = 1;
			bunifuBtnNext.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnNext.OnDisabledState.BorderThickness = 1;
			bunifuBtnNext.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnNext.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnNext.OnDisabledState.IconLeftImage = null;
			bunifuBtnNext.OnDisabledState.IconRightImage = null;
			bunifuBtnNext.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnNext.onHoverState.BorderRadius = 1;
			bunifuBtnNext.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnNext.onHoverState.BorderThickness = 1;
			bunifuBtnNext.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnNext.onHoverState.ForeColor = System.Drawing.Color.White;
			bunifuBtnNext.onHoverState.IconLeftImage = null;
			bunifuBtnNext.onHoverState.IconRightImage = null;
			bunifuBtnNext.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnNext.OnIdleState.BorderRadius = 1;
			bunifuBtnNext.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnNext.OnIdleState.BorderThickness = 1;
			bunifuBtnNext.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnNext.OnIdleState.ForeColor = System.Drawing.Color.White;
			bunifuBtnNext.OnIdleState.IconLeftImage = null;
			bunifuBtnNext.OnIdleState.IconRightImage = null;
			bunifuBtnNext.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnNext.OnPressedState.BorderRadius = 1;
			bunifuBtnNext.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnNext.OnPressedState.BorderThickness = 1;
			bunifuBtnNext.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnNext.OnPressedState.ForeColor = System.Drawing.Color.White;
			bunifuBtnNext.OnPressedState.IconLeftImage = null;
			bunifuBtnNext.OnPressedState.IconRightImage = null;
			bunifuBtnNext.Size = new System.Drawing.Size(92, 25);
			bunifuBtnNext.TabIndex = 6;
			bunifuBtnNext.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			bunifuBtnNext.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			bunifuBtnNext.TextMarginLeft = 0;
			bunifuBtnNext.TextPadding = new System.Windows.Forms.Padding(0);
			bunifuBtnNext.UseDefaultRadiusAndThickness = true;
			bunifuBtnNext.Click += new System.EventHandler(bunifuBtnNext_Click);
			bunifuBtnPrevious.AllowToggling = false;
			bunifuBtnPrevious.AnimationSpeed = 200;
			bunifuBtnPrevious.AutoGenerateColors = false;
			bunifuBtnPrevious.AutoSizeLeftIcon = true;
			bunifuBtnPrevious.AutoSizeRightIcon = true;
			bunifuBtnPrevious.BackColor = System.Drawing.Color.Transparent;
			bunifuBtnPrevious.BackColor1 = System.Drawing.Color.DodgerBlue;
			bunifuBtnPrevious.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuBtnPrevious.BackgroundImage");
			bunifuBtnPrevious.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnPrevious.ButtonText = "Trang trước";
			bunifuBtnPrevious.ButtonTextMarginLeft = 0;
			bunifuBtnPrevious.ColorContrastOnClick = 45;
			bunifuBtnPrevious.ColorContrastOnHover = 45;
			bunifuBtnPrevious.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges4.BottomLeft = true;
			borderEdges4.BottomRight = true;
			borderEdges4.TopLeft = true;
			borderEdges4.TopRight = true;
			bunifuBtnPrevious.CustomizableEdges = borderEdges4;
			bunifuBtnPrevious.DialogResult = System.Windows.Forms.DialogResult.None;
			bunifuBtnPrevious.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnPrevious.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnPrevious.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnPrevious.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			bunifuBtnPrevious.Font = new System.Drawing.Font("Segoe UI", 9f);
			bunifuBtnPrevious.ForeColor = System.Drawing.Color.White;
			bunifuBtnPrevious.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			bunifuBtnPrevious.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnPrevious.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			bunifuBtnPrevious.IconMarginLeft = 11;
			bunifuBtnPrevious.IconPadding = 10;
			bunifuBtnPrevious.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			bunifuBtnPrevious.IconRightCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnPrevious.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			bunifuBtnPrevious.IconSize = 25;
			bunifuBtnPrevious.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnPrevious.IdleBorderRadius = 1;
			bunifuBtnPrevious.IdleBorderThickness = 1;
			bunifuBtnPrevious.IdleFillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnPrevious.IdleIconLeftImage = null;
			bunifuBtnPrevious.IdleIconRightImage = null;
			bunifuBtnPrevious.IndicateFocus = false;
			bunifuBtnPrevious.Location = new System.Drawing.Point(208, 10);
			bunifuBtnPrevious.Name = "bunifuBtnPrevious";
			bunifuBtnPrevious.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnPrevious.OnDisabledState.BorderRadius = 1;
			bunifuBtnPrevious.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnPrevious.OnDisabledState.BorderThickness = 1;
			bunifuBtnPrevious.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnPrevious.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnPrevious.OnDisabledState.IconLeftImage = null;
			bunifuBtnPrevious.OnDisabledState.IconRightImage = null;
			bunifuBtnPrevious.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnPrevious.onHoverState.BorderRadius = 1;
			bunifuBtnPrevious.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnPrevious.onHoverState.BorderThickness = 1;
			bunifuBtnPrevious.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnPrevious.onHoverState.ForeColor = System.Drawing.Color.White;
			bunifuBtnPrevious.onHoverState.IconLeftImage = null;
			bunifuBtnPrevious.onHoverState.IconRightImage = null;
			bunifuBtnPrevious.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnPrevious.OnIdleState.BorderRadius = 1;
			bunifuBtnPrevious.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnPrevious.OnIdleState.BorderThickness = 1;
			bunifuBtnPrevious.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnPrevious.OnIdleState.ForeColor = System.Drawing.Color.White;
			bunifuBtnPrevious.OnIdleState.IconLeftImage = null;
			bunifuBtnPrevious.OnIdleState.IconRightImage = null;
			bunifuBtnPrevious.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnPrevious.OnPressedState.BorderRadius = 1;
			bunifuBtnPrevious.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnPrevious.OnPressedState.BorderThickness = 1;
			bunifuBtnPrevious.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnPrevious.OnPressedState.ForeColor = System.Drawing.Color.White;
			bunifuBtnPrevious.OnPressedState.IconLeftImage = null;
			bunifuBtnPrevious.OnPressedState.IconRightImage = null;
			bunifuBtnPrevious.Size = new System.Drawing.Size(92, 25);
			bunifuBtnPrevious.TabIndex = 7;
			bunifuBtnPrevious.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			bunifuBtnPrevious.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			bunifuBtnPrevious.TextMarginLeft = 0;
			bunifuBtnPrevious.TextPadding = new System.Windows.Forms.Padding(0);
			bunifuBtnPrevious.UseDefaultRadiusAndThickness = true;
			bunifuBtnPrevious.Click += new System.EventHandler(bunifuBtnPrevious_Click);
			bunifuBtnFirstPage.AllowToggling = false;
			bunifuBtnFirstPage.AnimationSpeed = 200;
			bunifuBtnFirstPage.AutoGenerateColors = false;
			bunifuBtnFirstPage.AutoSizeLeftIcon = true;
			bunifuBtnFirstPage.AutoSizeRightIcon = true;
			bunifuBtnFirstPage.BackColor = System.Drawing.Color.Transparent;
			bunifuBtnFirstPage.BackColor1 = System.Drawing.Color.DodgerBlue;
			bunifuBtnFirstPage.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuBtnFirstPage.BackgroundImage");
			bunifuBtnFirstPage.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnFirstPage.ButtonText = "Trang đầu";
			bunifuBtnFirstPage.ButtonTextMarginLeft = 0;
			bunifuBtnFirstPage.ColorContrastOnClick = 45;
			bunifuBtnFirstPage.ColorContrastOnHover = 45;
			bunifuBtnFirstPage.Cursor = System.Windows.Forms.Cursors.Default;
			borderEdges5.BottomLeft = true;
			borderEdges5.BottomRight = true;
			borderEdges5.TopLeft = true;
			borderEdges5.TopRight = true;
			bunifuBtnFirstPage.CustomizableEdges = borderEdges5;
			bunifuBtnFirstPage.DialogResult = System.Windows.Forms.DialogResult.None;
			bunifuBtnFirstPage.DisabledBorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnFirstPage.DisabledFillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnFirstPage.DisabledForecolor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnFirstPage.FocusState = Bunifu.UI.WinForms.BunifuButton.BunifuButton.ButtonStates.Pressed;
			bunifuBtnFirstPage.Font = new System.Drawing.Font("Segoe UI", 9f);
			bunifuBtnFirstPage.ForeColor = System.Drawing.Color.White;
			bunifuBtnFirstPage.IconLeftAlign = System.Drawing.ContentAlignment.MiddleLeft;
			bunifuBtnFirstPage.IconLeftCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnFirstPage.IconLeftPadding = new System.Windows.Forms.Padding(11, 3, 3, 3);
			bunifuBtnFirstPage.IconMarginLeft = 11;
			bunifuBtnFirstPage.IconPadding = 10;
			bunifuBtnFirstPage.IconRightAlign = System.Drawing.ContentAlignment.MiddleRight;
			bunifuBtnFirstPage.IconRightCursor = System.Windows.Forms.Cursors.Default;
			bunifuBtnFirstPage.IconRightPadding = new System.Windows.Forms.Padding(3, 3, 7, 3);
			bunifuBtnFirstPage.IconSize = 25;
			bunifuBtnFirstPage.IdleBorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnFirstPage.IdleBorderRadius = 1;
			bunifuBtnFirstPage.IdleBorderThickness = 1;
			bunifuBtnFirstPage.IdleFillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnFirstPage.IdleIconLeftImage = null;
			bunifuBtnFirstPage.IdleIconRightImage = null;
			bunifuBtnFirstPage.IndicateFocus = false;
			bunifuBtnFirstPage.Location = new System.Drawing.Point(110, 10);
			bunifuBtnFirstPage.Name = "bunifuBtnFirstPage";
			bunifuBtnFirstPage.OnDisabledState.BorderColor = System.Drawing.Color.FromArgb(191, 191, 191);
			bunifuBtnFirstPage.OnDisabledState.BorderRadius = 1;
			bunifuBtnFirstPage.OnDisabledState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnFirstPage.OnDisabledState.BorderThickness = 1;
			bunifuBtnFirstPage.OnDisabledState.FillColor = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuBtnFirstPage.OnDisabledState.ForeColor = System.Drawing.Color.FromArgb(168, 160, 168);
			bunifuBtnFirstPage.OnDisabledState.IconLeftImage = null;
			bunifuBtnFirstPage.OnDisabledState.IconRightImage = null;
			bunifuBtnFirstPage.onHoverState.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnFirstPage.onHoverState.BorderRadius = 1;
			bunifuBtnFirstPage.onHoverState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnFirstPage.onHoverState.BorderThickness = 1;
			bunifuBtnFirstPage.onHoverState.FillColor = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuBtnFirstPage.onHoverState.ForeColor = System.Drawing.Color.White;
			bunifuBtnFirstPage.onHoverState.IconLeftImage = null;
			bunifuBtnFirstPage.onHoverState.IconRightImage = null;
			bunifuBtnFirstPage.OnIdleState.BorderColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnFirstPage.OnIdleState.BorderRadius = 1;
			bunifuBtnFirstPage.OnIdleState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnFirstPage.OnIdleState.BorderThickness = 1;
			bunifuBtnFirstPage.OnIdleState.FillColor = System.Drawing.Color.DodgerBlue;
			bunifuBtnFirstPage.OnIdleState.ForeColor = System.Drawing.Color.White;
			bunifuBtnFirstPage.OnIdleState.IconLeftImage = null;
			bunifuBtnFirstPage.OnIdleState.IconRightImage = null;
			bunifuBtnFirstPage.OnPressedState.BorderColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnFirstPage.OnPressedState.BorderRadius = 1;
			bunifuBtnFirstPage.OnPressedState.BorderStyle = Bunifu.UI.WinForms.BunifuButton.BunifuButton.BorderStyles.Solid;
			bunifuBtnFirstPage.OnPressedState.BorderThickness = 1;
			bunifuBtnFirstPage.OnPressedState.FillColor = System.Drawing.Color.FromArgb(40, 96, 144);
			bunifuBtnFirstPage.OnPressedState.ForeColor = System.Drawing.Color.White;
			bunifuBtnFirstPage.OnPressedState.IconLeftImage = null;
			bunifuBtnFirstPage.OnPressedState.IconRightImage = null;
			bunifuBtnFirstPage.Size = new System.Drawing.Size(92, 25);
			bunifuBtnFirstPage.TabIndex = 8;
			bunifuBtnFirstPage.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
			bunifuBtnFirstPage.TextAlignment = System.Windows.Forms.HorizontalAlignment.Center;
			bunifuBtnFirstPage.TextMarginLeft = 0;
			bunifuBtnFirstPage.TextPadding = new System.Windows.Forms.Padding(0);
			bunifuBtnFirstPage.UseDefaultRadiusAndThickness = true;
			bunifuBtnFirstPage.Click += new System.EventHandler(bunifuBtnFirstPage_Click);
			bunifuTxtCurentPage.AcceptsReturn = false;
			bunifuTxtCurentPage.AcceptsTab = false;
			bunifuTxtCurentPage.AnimationSpeed = 200;
			bunifuTxtCurentPage.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.None;
			bunifuTxtCurentPage.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.None;
			bunifuTxtCurentPage.BackColor = System.Drawing.Color.Transparent;
			bunifuTxtCurentPage.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuTxtCurentPage.BackgroundImage");
			bunifuTxtCurentPage.BorderColorActive = System.Drawing.Color.DodgerBlue;
			bunifuTxtCurentPage.BorderColorDisabled = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuTxtCurentPage.BorderColorHover = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuTxtCurentPage.BorderColorIdle = System.Drawing.Color.Silver;
			bunifuTxtCurentPage.BorderRadius = 1;
			bunifuTxtCurentPage.BorderThickness = 1;
			bunifuTxtCurentPage.CharacterCasing = System.Windows.Forms.CharacterCasing.Normal;
			bunifuTxtCurentPage.Cursor = System.Windows.Forms.Cursors.IBeam;
			bunifuTxtCurentPage.DefaultFont = new System.Drawing.Font("Segoe UI", 9.25f);
			bunifuTxtCurentPage.DefaultText = "";
			bunifuTxtCurentPage.FillColor = System.Drawing.Color.White;
			bunifuTxtCurentPage.HideSelection = true;
			bunifuTxtCurentPage.IconLeft = null;
			bunifuTxtCurentPage.IconLeftCursor = System.Windows.Forms.Cursors.IBeam;
			bunifuTxtCurentPage.IconPadding = 10;
			bunifuTxtCurentPage.IconRight = null;
			bunifuTxtCurentPage.IconRightCursor = System.Windows.Forms.Cursors.IBeam;
			bunifuTxtCurentPage.Lines = new string[0];
			bunifuTxtCurentPage.Location = new System.Drawing.Point(387, 10);
			bunifuTxtCurentPage.MaxLength = 32767;
			bunifuTxtCurentPage.MinimumSize = new System.Drawing.Size(1, 1);
			bunifuTxtCurentPage.Modified = false;
			bunifuTxtCurentPage.Multiline = false;
			bunifuTxtCurentPage.Name = "bunifuTxtCurentPage";
			stateProperties.BorderColor = System.Drawing.Color.DodgerBlue;
			stateProperties.FillColor = System.Drawing.Color.Empty;
			stateProperties.ForeColor = System.Drawing.Color.Empty;
			stateProperties.PlaceholderForeColor = System.Drawing.Color.Empty;
			bunifuTxtCurentPage.OnActiveState = stateProperties;
			stateProperties2.BorderColor = System.Drawing.Color.FromArgb(204, 204, 204);
			stateProperties2.FillColor = System.Drawing.Color.FromArgb(240, 240, 240);
			stateProperties2.ForeColor = System.Drawing.Color.FromArgb(109, 109, 109);
			stateProperties2.PlaceholderForeColor = System.Drawing.Color.DarkGray;
			bunifuTxtCurentPage.OnDisabledState = stateProperties2;
			stateProperties3.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			stateProperties3.FillColor = System.Drawing.Color.Empty;
			stateProperties3.ForeColor = System.Drawing.Color.Empty;
			stateProperties3.PlaceholderForeColor = System.Drawing.Color.Empty;
			bunifuTxtCurentPage.OnHoverState = stateProperties3;
			stateProperties4.BorderColor = System.Drawing.Color.Silver;
			stateProperties4.FillColor = System.Drawing.Color.White;
			stateProperties4.ForeColor = System.Drawing.Color.Empty;
			stateProperties4.PlaceholderForeColor = System.Drawing.Color.Empty;
			bunifuTxtCurentPage.OnIdleState = stateProperties4;
			bunifuTxtCurentPage.Padding = new System.Windows.Forms.Padding(3);
			bunifuTxtCurentPage.PasswordChar = '\0';
			bunifuTxtCurentPage.PlaceholderForeColor = System.Drawing.Color.Silver;
			bunifuTxtCurentPage.PlaceholderText = "Enter text";
			bunifuTxtCurentPage.ReadOnly = false;
			bunifuTxtCurentPage.ScrollBars = System.Windows.Forms.ScrollBars.None;
			bunifuTxtCurentPage.SelectedText = "";
			bunifuTxtCurentPage.SelectionLength = 0;
			bunifuTxtCurentPage.SelectionStart = 0;
			bunifuTxtCurentPage.ShortcutsEnabled = true;
			bunifuTxtCurentPage.Size = new System.Drawing.Size(73, 25);
			bunifuTxtCurentPage.Style = Bunifu.UI.WinForms.BunifuTextBox._Style.Bunifu;
			bunifuTxtCurentPage.TabIndex = 3;
			bunifuTxtCurentPage.TextAlign = System.Windows.Forms.HorizontalAlignment.Left;
			bunifuTxtCurentPage.TextMarginBottom = 0;
			bunifuTxtCurentPage.TextMarginLeft = 3;
			bunifuTxtCurentPage.TextMarginTop = 0;
			bunifuTxtCurentPage.TextPlaceholder = "Enter text";
			bunifuTxtCurentPage.UseSystemPasswordChar = false;
			bunifuTxtCurentPage.WordWrap = true;
			bunifuTxtCurentPage.TextChange += new System.EventHandler(bunifuTxtCurentPage_TextChange);
			bunifuTxtCurentPage.KeyUp += new System.Windows.Forms.KeyEventHandler(bunifuTxtCurentPage_KeyUp);
			lbPageCount.AutoSize = true;
			lbPageCount.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			lbPageCount.Location = new System.Drawing.Point(463, 15);
			lbPageCount.Name = "lbPageCount";
			lbPageCount.Size = new System.Drawing.Size(23, 15);
			lbPageCount.TabIndex = 2;
			lbPageCount.Text = "/ 1";
			labelTotalRecords.AutoSize = true;
			labelTotalRecords.Font = new System.Drawing.Font("Microsoft Sans Serif", 9f, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, 0);
			labelTotalRecords.Location = new System.Drawing.Point(857, 14);
			labelTotalRecords.Name = "labelTotalRecords";
			labelTotalRecords.Size = new System.Drawing.Size(74, 15);
			labelTotalRecords.TabIndex = 2;
			labelTotalRecords.Text = "Tổng số: 0";
			panel3.Controls.Add(label1);
			panel3.Dock = System.Windows.Forms.DockStyle.Top;
			panel3.Location = new System.Drawing.Point(0, 0);
			panel3.Name = "panel3";
			panel3.Size = new System.Drawing.Size(1000, 36);
			panel3.TabIndex = 5;
			label1.AutoSize = true;
			label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9.75f, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, 0);
			label1.ForeColor = System.Drawing.Color.Red;
			label1.Location = new System.Drawing.Point(223, 10);
			label1.Name = "label1";
			label1.Size = new System.Drawing.Size(554, 16);
			label1.TabIndex = 2;
			label1.Text = "Hệ thống kiểm tra thẻ từ 2 đến 3 phút, trạng thái Thành công Cash sẽ được thêm vào tài khoản";
			panel2.Controls.Add(picBoxSearch);
			panel2.Controls.Add(bunifuTxtSearch);
			panel2.Controls.Add(dgvExchangeLog);
			panel2.Dock = System.Windows.Forms.DockStyle.Fill;
			panel2.Location = new System.Drawing.Point(0, 36);
			panel2.Name = "panel2";
			panel2.Size = new System.Drawing.Size(1000, 514);
			panel2.TabIndex = 6;
			picBoxSearch.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			picBoxSearch.Image = Resources.loupe;
			picBoxSearch.Location = new System.Drawing.Point(23, 15);
			picBoxSearch.Name = "picBoxSearch";
			picBoxSearch.Size = new System.Drawing.Size(30, 30);
			picBoxSearch.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			picBoxSearch.TabIndex = 2;
			picBoxSearch.TabStop = false;
			bunifuTxtSearch.AcceptsReturn = false;
			bunifuTxtSearch.AcceptsTab = false;
			bunifuTxtSearch.AnimationSpeed = 200;
			bunifuTxtSearch.AutoCompleteMode = System.Windows.Forms.AutoCompleteMode.None;
			bunifuTxtSearch.AutoCompleteSource = System.Windows.Forms.AutoCompleteSource.None;
			bunifuTxtSearch.BackColor = System.Drawing.Color.Transparent;
			bunifuTxtSearch.BackgroundImage = (System.Drawing.Image)resources.GetObject("bunifuTxtSearch.BackgroundImage");
			bunifuTxtSearch.BorderColorActive = System.Drawing.Color.DodgerBlue;
			bunifuTxtSearch.BorderColorDisabled = System.Drawing.Color.FromArgb(204, 204, 204);
			bunifuTxtSearch.BorderColorHover = System.Drawing.Color.FromArgb(105, 181, 255);
			bunifuTxtSearch.BorderColorIdle = System.Drawing.Color.DimGray;
			bunifuTxtSearch.BorderRadius = 1;
			bunifuTxtSearch.BorderThickness = 1;
			bunifuTxtSearch.CharacterCasing = System.Windows.Forms.CharacterCasing.Normal;
			bunifuTxtSearch.Cursor = System.Windows.Forms.Cursors.IBeam;
			bunifuTxtSearch.DefaultFont = new System.Drawing.Font("Segoe UI", 9.25f);
			bunifuTxtSearch.DefaultText = "";
			bunifuTxtSearch.FillColor = System.Drawing.Color.White;
			bunifuTxtSearch.ForeColor = System.Drawing.Color.Black;
			bunifuTxtSearch.HideSelection = true;
			bunifuTxtSearch.IconLeft = null;
			bunifuTxtSearch.IconLeftCursor = System.Windows.Forms.Cursors.IBeam;
			bunifuTxtSearch.IconPadding = 10;
			bunifuTxtSearch.IconRight = null;
			bunifuTxtSearch.IconRightCursor = System.Windows.Forms.Cursors.IBeam;
			bunifuTxtSearch.Lines = new string[0];
			bunifuTxtSearch.Location = new System.Drawing.Point(51, 15);
			bunifuTxtSearch.MaxLength = 32767;
			bunifuTxtSearch.MinimumSize = new System.Drawing.Size(1, 1);
			bunifuTxtSearch.Modified = false;
			bunifuTxtSearch.Multiline = false;
			bunifuTxtSearch.Name = "bunifuTxtSearch";
			stateProperties5.BorderColor = System.Drawing.Color.DodgerBlue;
			stateProperties5.FillColor = System.Drawing.Color.Empty;
			stateProperties5.ForeColor = System.Drawing.Color.Empty;
			stateProperties5.PlaceholderForeColor = System.Drawing.Color.Empty;
			bunifuTxtSearch.OnActiveState = stateProperties5;
			stateProperties6.BorderColor = System.Drawing.Color.FromArgb(204, 204, 204);
			stateProperties6.FillColor = System.Drawing.Color.FromArgb(240, 240, 240);
			stateProperties6.ForeColor = System.Drawing.Color.FromArgb(109, 109, 109);
			stateProperties6.PlaceholderForeColor = System.Drawing.Color.DarkGray;
			bunifuTxtSearch.OnDisabledState = stateProperties6;
			stateProperties7.BorderColor = System.Drawing.Color.FromArgb(105, 181, 255);
			stateProperties7.FillColor = System.Drawing.Color.Empty;
			stateProperties7.ForeColor = System.Drawing.Color.Empty;
			stateProperties7.PlaceholderForeColor = System.Drawing.Color.Empty;
			bunifuTxtSearch.OnHoverState = stateProperties7;
			stateProperties8.BorderColor = System.Drawing.Color.DimGray;
			stateProperties8.FillColor = System.Drawing.Color.White;
			stateProperties8.ForeColor = System.Drawing.Color.Black;
			stateProperties8.PlaceholderForeColor = System.Drawing.Color.Empty;
			bunifuTxtSearch.OnIdleState = stateProperties8;
			bunifuTxtSearch.Padding = new System.Windows.Forms.Padding(3);
			bunifuTxtSearch.PasswordChar = '\0';
			bunifuTxtSearch.PlaceholderForeColor = System.Drawing.Color.Silver;
			bunifuTxtSearch.PlaceholderText = "Enter text";
			bunifuTxtSearch.ReadOnly = false;
			bunifuTxtSearch.ScrollBars = System.Windows.Forms.ScrollBars.None;
			bunifuTxtSearch.SelectedText = "";
			bunifuTxtSearch.SelectionLength = 0;
			bunifuTxtSearch.SelectionStart = 0;
			bunifuTxtSearch.ShortcutsEnabled = true;
			bunifuTxtSearch.Size = new System.Drawing.Size(929, 30);
			bunifuTxtSearch.Style = Bunifu.UI.WinForms.BunifuTextBox._Style.Bunifu;
			bunifuTxtSearch.TabIndex = 3;
			bunifuTxtSearch.TextAlign = System.Windows.Forms.HorizontalAlignment.Left;
			bunifuTxtSearch.TextMarginBottom = 0;
			bunifuTxtSearch.TextMarginLeft = 3;
			bunifuTxtSearch.TextMarginTop = 0;
			bunifuTxtSearch.TextPlaceholder = "Enter text";
			bunifuTxtSearch.UseSystemPasswordChar = false;
			bunifuTxtSearch.WordWrap = true;
			bunifuTxtSearch.KeyUp += new System.Windows.Forms.KeyEventHandler(bunifuTxtSearch_KeyUp);
			dgvExchangeLog.AllowCustomTheming = false;
			dgvExchangeLog.AllowUserToAddRows = false;
			dgvExchangeLog.AllowUserToDeleteRows = false;
			dataGridViewCellStyle.BackColor = System.Drawing.Color.FromArgb(248, 251, 255);
			dataGridViewCellStyle.ForeColor = System.Drawing.Color.Black;
			dgvExchangeLog.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle;
			dgvExchangeLog.Anchor = System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right;
			dgvExchangeLog.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
			dgvExchangeLog.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
			dgvExchangeLog.BackgroundColor = System.Drawing.Color.White;
			dgvExchangeLog.BorderStyle = System.Windows.Forms.BorderStyle.None;
			dgvExchangeLog.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.SingleHorizontal;
			dgvExchangeLog.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.None;
			dataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
			dataGridViewCellStyle2.BackColor = System.Drawing.Color.DodgerBlue;
			dataGridViewCellStyle2.Font = new System.Drawing.Font("Segoe UI Semibold", 11.75f, System.Drawing.FontStyle.Bold);
			dataGridViewCellStyle2.ForeColor = System.Drawing.Color.White;
			dataGridViewCellStyle2.SelectionBackColor = System.Drawing.Color.FromArgb(24, 115, 204);
			dataGridViewCellStyle2.SelectionForeColor = System.Drawing.Color.White;
			dataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
			dgvExchangeLog.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle2;
			dgvExchangeLog.ColumnHeadersHeight = 40;
			dgvExchangeLog.Columns.AddRange(dgvExchangeLogID, dgvExchangeLogNameCard, dgvExchangeLogSerial, dgvExchangeLogCodeCard, dgvExchangeLogValueCard, dgvExchangeLogStatus, dgvExchangeLogTimeCreate);
			dgvExchangeLog.CurrentTheme.AlternatingRowsStyle.BackColor = System.Drawing.Color.FromArgb(248, 251, 255);
			dgvExchangeLog.CurrentTheme.AlternatingRowsStyle.Font = new System.Drawing.Font("Segoe UI Semibold", 9.75f, System.Drawing.FontStyle.Bold);
			dgvExchangeLog.CurrentTheme.AlternatingRowsStyle.ForeColor = System.Drawing.Color.Black;
			dgvExchangeLog.CurrentTheme.AlternatingRowsStyle.SelectionBackColor = System.Drawing.Color.FromArgb(210, 232, 255);
			dgvExchangeLog.CurrentTheme.AlternatingRowsStyle.SelectionForeColor = System.Drawing.Color.Black;
			dgvExchangeLog.CurrentTheme.BackColor = System.Drawing.Color.White;
			dgvExchangeLog.CurrentTheme.GridColor = System.Drawing.Color.FromArgb(221, 238, 255);
			dgvExchangeLog.CurrentTheme.HeaderStyle.BackColor = System.Drawing.Color.DodgerBlue;
			dgvExchangeLog.CurrentTheme.HeaderStyle.Font = new System.Drawing.Font("Segoe UI Semibold", 11.75f, System.Drawing.FontStyle.Bold);
			dgvExchangeLog.CurrentTheme.HeaderStyle.ForeColor = System.Drawing.Color.White;
			dgvExchangeLog.CurrentTheme.HeaderStyle.SelectionBackColor = System.Drawing.Color.FromArgb(24, 115, 204);
			dgvExchangeLog.CurrentTheme.HeaderStyle.SelectionForeColor = System.Drawing.Color.White;
			dgvExchangeLog.CurrentTheme.Name = null;
			dgvExchangeLog.CurrentTheme.RowsStyle.BackColor = System.Drawing.Color.White;
			dgvExchangeLog.CurrentTheme.RowsStyle.Font = new System.Drawing.Font("Segoe UI Semibold", 9.75f, System.Drawing.FontStyle.Bold);
			dgvExchangeLog.CurrentTheme.RowsStyle.ForeColor = System.Drawing.Color.Black;
			dgvExchangeLog.CurrentTheme.RowsStyle.SelectionBackColor = System.Drawing.Color.FromArgb(210, 232, 255);
			dgvExchangeLog.CurrentTheme.RowsStyle.SelectionForeColor = System.Drawing.Color.Black;
			dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
			dataGridViewCellStyle3.BackColor = System.Drawing.Color.White;
			dataGridViewCellStyle3.Font = new System.Drawing.Font("Segoe UI Semibold", 9.75f, System.Drawing.FontStyle.Bold);
			dataGridViewCellStyle3.ForeColor = System.Drawing.Color.Black;
			dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.FromArgb(210, 232, 255);
			dataGridViewCellStyle3.SelectionForeColor = System.Drawing.Color.Black;
			dataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
			dgvExchangeLog.DefaultCellStyle = dataGridViewCellStyle3;
			dgvExchangeLog.EnableHeadersVisualStyles = false;
			dgvExchangeLog.GridColor = System.Drawing.Color.FromArgb(221, 238, 255);
			dgvExchangeLog.HeaderBackColor = System.Drawing.Color.DodgerBlue;
			dgvExchangeLog.HeaderBgColor = System.Drawing.Color.Empty;
			dgvExchangeLog.HeaderForeColor = System.Drawing.Color.White;
			dgvExchangeLog.Location = new System.Drawing.Point(22, 56);
			dgvExchangeLog.Name = "dgvExchangeLog";
			dgvExchangeLog.ReadOnly = true;
			dgvExchangeLog.RowHeadersVisible = false;
			dgvExchangeLog.RowHeadersWidth = 40;
			dgvExchangeLog.RowTemplate.DividerHeight = 2;
			dgvExchangeLog.RowTemplate.Height = 40;
			dgvExchangeLog.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
			dgvExchangeLog.Size = new System.Drawing.Size(958, 458);
			dgvExchangeLog.TabIndex = 0;
			dgvExchangeLog.Theme = Bunifu.UI.WinForms.BunifuDataGridView.PresetThemes.Light;
			dgvExchangeLogID.DataPropertyName = "ID";
			dgvExchangeLogID.FillWeight = 55f;
			dgvExchangeLogID.HeaderText = "ID";
			dgvExchangeLogID.Name = "dgvExchangeLogID";
			dgvExchangeLogID.ReadOnly = true;
			dgvExchangeLogNameCard.DataPropertyName = "NameCard";
			dgvExchangeLogNameCard.FillWeight = 75f;
			dgvExchangeLogNameCard.HeaderText = "Loại thẻ";
			dgvExchangeLogNameCard.Name = "dgvExchangeLogNameCard";
			dgvExchangeLogNameCard.ReadOnly = true;
			dgvExchangeLogSerial.DataPropertyName = "Serial";
			dgvExchangeLogSerial.FillWeight = 85f;
			dgvExchangeLogSerial.HeaderText = "Serial";
			dgvExchangeLogSerial.Name = "dgvExchangeLogSerial";
			dgvExchangeLogSerial.ReadOnly = true;
			dgvExchangeLogCodeCard.DataPropertyName = "CodeCard";
			dgvExchangeLogCodeCard.FillWeight = 85f;
			dgvExchangeLogCodeCard.HeaderText = "Mã thẻ";
			dgvExchangeLogCodeCard.Name = "dgvExchangeLogCodeCard";
			dgvExchangeLogCodeCard.ReadOnly = true;
			dgvExchangeLogValueCard.DataPropertyName = "ValueCard";
			dgvExchangeLogValueCard.FillWeight = 80.55173f;
			dgvExchangeLogValueCard.HeaderText = "Mệnh giá";
			dgvExchangeLogValueCard.Name = "dgvExchangeLogValueCard";
			dgvExchangeLogValueCard.ReadOnly = true;
			dgvExchangeLogStatus.DataPropertyName = "Status";
			dgvExchangeLogStatus.FillWeight = 80.55173f;
			dgvExchangeLogStatus.HeaderText = "Trạng thái";
			dgvExchangeLogStatus.Name = "dgvExchangeLogStatus";
			dgvExchangeLogStatus.ReadOnly = true;
			dgvExchangeLogTimeCreate.DataPropertyName = "TimeCreate";
			dgvExchangeLogTimeCreate.FillWeight = 95f;
			dgvExchangeLogTimeCreate.HeaderText = "Thời gian";
			dgvExchangeLogTimeCreate.Name = "dgvExchangeLogTimeCreate";
			dgvExchangeLogTimeCreate.ReadOnly = true;
			base.AutoScaleDimensions = new System.Drawing.SizeF(6f, 13f);
			base.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			BackColor = System.Drawing.Color.White;
			base.Controls.Add(panel2);
			base.Controls.Add(panel3);
			base.Controls.Add(panel1);
			base.Name = "HistoryTopUp";
			base.Size = new System.Drawing.Size(1000, 595);
			base.Load += new System.EventHandler(HistoryTopUp_Load);
			base.Enter += new System.EventHandler(HistoryTopUp_Enter);
			panel1.ResumeLayout(false);
			panel1.PerformLayout();
			panel3.ResumeLayout(false);
			panel3.PerformLayout();
			panel2.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)picBoxSearch).EndInit();
			((System.ComponentModel.ISupportInitialize)dgvExchangeLog).EndInit();
			ResumeLayout(false);
		}

		internal static void zo0FsympUnvBfl2S9Jf()
		{
		}

		internal static void BQGEBVmfBeot8MLYWo5()
		{
		}

		internal static bool JxVdslm214dJiLRokqn()
		{
			return Is0gegmPon9hV6hXJ1o == null;
		}
	}
}
