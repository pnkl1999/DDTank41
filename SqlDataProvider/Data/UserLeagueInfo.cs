using System;
namespace SqlDataProvider.Data
{
    public class UserLeagueInfo : DataObject
    {
        private int _iD;
        private int _userID;
        private int _rankID;
        private int _point;
        private int _win;
        private int _lose;
        private bool _isBanned;
        private DateTime _forbidDate;
        private string _forbidReason;
        public int ID { get => _iD; set => _iD = value; }
        public int UserID { get => _userID; set => _userID = value; }
        public int RankID { get => _rankID; set => _rankID = value; }
        public int Point { get => _point; set => _point = value; }
        public int Win { get => _win; set => _win = value; }
        public int Lose { get => _lose; set => _lose = value; }
        public bool IsBanned { get => _isBanned; set => _isBanned = value; }
        public DateTime ForbidDate { get => _forbidDate; set => _forbidDate = value; }
        public string ForbidReason { get => _forbidReason; set => _forbidReason = value; }
    }
}
