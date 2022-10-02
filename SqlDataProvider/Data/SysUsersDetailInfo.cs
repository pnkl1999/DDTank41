using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class SysUsersDetailInfo : DataObject
    {
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private int _userAllGP;
        public int UserAllGP
        {
            get { return _userAllGP; }
            set { _userAllGP = value; _isDirty = true; }
        }
        private int _userMoneyPay;
        public int UserMoneyPay
        {
            get { return _userMoneyPay; }
            set { _userMoneyPay = value; _isDirty = true; }
        }
        private int _userMoneyWar;
        public int UserMoneyWar
        {
            get { return _userMoneyWar; }
            set { _userMoneyWar = value; _isDirty = true; }
        }
        private int _userMoneyShop;
        public int UserMoneyShop
        {
            get { return _userMoneyShop; }
            set { _userMoneyShop = value; _isDirty = true; }
        }
    }
}