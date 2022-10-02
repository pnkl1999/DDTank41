using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class UserBankInfo : DataObject
    {
        private int _BankID;

        public int BankID
        {
            get { return _BankID; }
            set { _BankID = value; _isDirty = true; }
        }

        private int _TempID;

        public int TempID
        {
            get { return _TempID; }
            set { _TempID = value; _isDirty = true; }
        }

        private int _UserID;

        public int UserID
        {
            get { return _UserID; }
            set { _UserID = value; _isDirty = true; }
        }

        private int _Amount;

        public int Amount
        {
            get { return _Amount; }
            set { _Amount = value; _isDirty = true; }
        }

        private DateTime _BeginTime;

        public DateTime BeginTime
        {
            get { return _BeginTime; }
            set { _BeginTime = value; _isDirty = true; }
        }

        private bool _IsExits;

        public bool IsExits
        {
            get { return _IsExits; }
            set { _IsExits = value; _isDirty = true; }
        }

        public bool IsAchieve(int month)
        {
            int totalDays = (DateTime.Now - _BeginTime).Days;

            if (totalDays >= month * 30)
                return true;

            return false;
        }
    }
}
