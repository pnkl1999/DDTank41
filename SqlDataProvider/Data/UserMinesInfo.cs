using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class UserMinesInfo : DataObject
    {
        private int _UserID;

        public int UserID
        {
            get { return _UserID; }
            set { _UserID = value; _isDirty = true; }
        }

        private int _ToolExp;

        public int ToolExp
        {
            get { return _ToolExp; }
            set { _ToolExp = value; _isDirty = true; }
        }

        private int _HeadExp;

        public int HeadExp
        {
            get { return _HeadExp; }
            set { _HeadExp = value; _isDirty = true; }
        }

        private int _ClothExp;

        public int ClothExp
        {
            get { return _ClothExp; }
            set { _ClothExp = value; _isDirty = true; }
        }

        private int _WeaponExp;

        public int WeaponExp
        {
            get { return _WeaponExp;  }
            set { _WeaponExp = value; _isDirty = true; }
        }

        private int _ShieldExp;

        public int ShieldExp
        {
            get { return _ShieldExp; }
            set { _ShieldExp = value; _isDirty = true; }
        }

        private DateTime _LastTimeDig;

        public DateTime LastTimeDig
        {
            get { return _LastTimeDig; }
            set { _LastTimeDig = value; _isDirty = true; }
        }

        private int _TotalTimesDig;

        public int TotalTimesDig
        {
            get { return _TotalTimesDig; }
            set { _TotalTimesDig = value; _isDirty = true; }
        }
    }
}
