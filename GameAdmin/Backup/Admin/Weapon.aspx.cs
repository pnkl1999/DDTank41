using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AdminGunny.Admin
{
    public partial class Weapon : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Active_btn.Visible = false;
                DeActive_btn.Visible = false;
                UserViewPanel.Visible = false;
                UserEditPanel.Visible = false;
                error_lbl.Text = string.Empty;
            }
        }

        protected void Search_Click(object sender, EventArgs e)
        {
            var business = new Bussiness.PlayerBussiness();
            var player = business.GetUserSingleByNickName(UserName_tbx.Text.Trim());

            if (player == null)
            {

                error_lbl.Text = "Username is not exits or do not Active, click Active to change it.";
                Active_btn.Visible = true;
            }
            else if (UserName_tbx.Text=="") 
            {
                error_lbl.Text = "You must enter UserName!";
            }
            else
            {
                error_lbl.Text = string.Empty;
                SearchPanel.Visible = false;
                UserEditPanel.Visible = false;
                UserViewPanel.Visible = true;
                DeActive_btn.Visible = true;
                Active_btn.Visible = false;
                //view data
                IDLabel.Text = Convert.ToString(player.ID);
                UserNameLabel.Text = player.UserName ;
                NickNameLabel.Text = player.NickName ;
                GenderLabel.Text = player.Sex == true ? "Nam" : "Nữ";
                GoldLabel.Text = Convert.ToString(player.Gold);
                MoneyLabel.Text = Convert.ToString(player.Money);
                GiftTokenLabel.Text = Convert.ToString(player.GiftToken);
                GPLabel.Text = Convert.ToString(player.GP);
                PvePermissionLabel.Text = player.PvePermission;

            }

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Active_btn.Visible = false;
            DeActive_btn.Visible = false;
            UserViewPanel.Visible = false;
            UserEditPanel.Visible = false;
            SearchPanel.Visible = true;
            error_lbl.Text = string.Empty;
            UserName_tbx.Text = string.Empty;
            //Response.Redirect("UserEdit.aspx");
            
        }

        protected void Active_btn_Click(object sender, EventArgs e)
        {
            var business = new Bussiness.PlayerBussiness();
            //var player = business.DisableUser(UserName_tbx.Text.Trim(), true);
            business.DisableUser(UserName_tbx.Text.Trim(), true);
            Button1_Click(sender, e);

        }

        protected void DeActive_btn_Click(object sender, EventArgs e)
        {
            var business = new Bussiness.PlayerBussiness();
            //var player = business.DisableUser(UserName_tbx.Text.Trim(), false);
            business.DisableUser(UserName_tbx.Text.Trim(), false);
            Button1_Click(sender, e);
        }

       protected void Edit_Click(object sender, EventArgs e)
        {
            error_lbl.Text = string.Empty;
            SearchPanel.Visible = false;
            UserEditPanel.Visible = true;
            UserViewPanel.Visible = false;
            DeActive_btn.Visible = false;
            Active_btn.Visible = false;
           //Update data
            var business = new Bussiness.PlayerBussiness();
            var player = business.GetUserSingleByNickName(UserName_tbx.Text.Trim());

            UserNameLabel1.Text = player.UserName;
            NickNameLabel1.Text = player.NickName;

            GoldTextbox.Text = Convert.ToString(player.Gold);
            MoneyTextbox.Text = Convert.ToString(player.Money);
            GiftTokenTextbox.Text = Convert.ToString(player.GiftToken);
            GPTextbox.Text = Convert.ToString(player.GP);
            PvePermissionTextbox.Text = player.PvePermission;
           
            
        }

       protected void Update_Click(object sender, EventArgs e)
       {
           var business = new Bussiness.PlayerBussiness();
           var player = business.GetUserSingleByNickName(UserName_tbx.Text.Trim());
           if (player != null)
           {
               player.GiftToken = int.Parse(GiftTokenTextbox.Text.Trim());
               player.Gold = int.Parse(GoldTextbox.Text.Trim());
               player.Money = int.Parse(MoneyTextbox.Text.Trim());
               player.PvePermission = PvePermissionTextbox.Text.Trim();               
               business.UpdatePlayer(player);
               Search_Click(sender, e);
           }
       }

       protected void Button2_Click(object sender, EventArgs e)
       {
           Search_Click(sender, e);
       }

      
    }
}