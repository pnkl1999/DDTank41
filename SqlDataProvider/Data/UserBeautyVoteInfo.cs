using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class UserBeautyVoteInfo : DataObject
    {
        private int _UserID;

        public int UserID
        {
            get { return _UserID; }
            set { _UserID = value; _isDirty = true; }
        }

        private string _UserName;

        public string UserName
        {
            get { return _UserName; }
            set { _UserName = value; _isDirty = true; }
        }
        private string _NickName;

        public string NickName
        {
            get { return _NickName; }
            set { _NickName = value; _isDirty = true; }
        }
        private int _Rank;

        public int Rank
        {
            get { return _Rank; }
            set { _Rank = value; _isDirty = true; }
        }
        private int _Count;

        public int Count
        {
            get { return _Count; }
            set { _Count = value; _isDirty = true; }
        }
        private string _Style;

        public string Style
        {
            get { return _Style; }
            set { _Style = value; _isDirty = true; }
        }
        private string _Color;

        public string Color
        {
            get { return _Color; }
            set { _Color = value; _isDirty = true; }
        }
        private DateTime _TimeCreate;

        public DateTime TimeCreate
        {
            get { return _TimeCreate; }
            set { _TimeCreate = value; _isDirty = true; }
        }

        private bool _IsSendAward;

        public bool IsSendAward
        {
            get { return _IsSendAward; }
            set { _IsSendAward = value; _isDirty = true; }
        }

    }
}
