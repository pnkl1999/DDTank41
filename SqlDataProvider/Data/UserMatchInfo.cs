namespace SqlDataProvider.Data
{
    public class UserMatchInfo : DataObject
    {
        private int _addDayPrestge;

        private int _dailyGameCount;

        private bool _DailyLeagueFirst;

        private int _DailyLeagueLastScore;

        private int _dailyScore;

        private int _dailyWinCount;

        private int _ID;

        private int _maxCount;

        private int _rank;

        private int _restCount;

        private int _totalPrestige;

        private int _userID;

        private int _weeklyGameCount;

        private int _weeklyWinCount;

        private int _weeklyRanking;

        private int _weeklyScore;

        private int _leagueGrade;

        private int _leagueItemsGet;

        public int addDayPrestge
        {
            get
            {
                return _addDayPrestge;
            }
            set
            {
                _addDayPrestge = value;
                _isDirty = true;
            }
        }

        public int dailyGameCount
        {
            get
            {
                return _dailyGameCount;
            }
            set
            {
                _dailyGameCount = value;
                _isDirty = true;
            }
        }

        public bool DailyLeagueFirst
        {
            get
            {
                return _DailyLeagueFirst;
            }
            set
            {
                _DailyLeagueFirst = value;
                _isDirty = true;
            }
        }

        public int DailyLeagueLastScore
        {
            get
            {
                return _DailyLeagueLastScore;
            }
            set
            {
                _DailyLeagueLastScore = value;
                _isDirty = true;
            }
        }

        public int dailyScore
        {
            get
            {
                return _dailyScore;
            }
            set
            {
                _dailyScore = value;
                _isDirty = true;
            }
        }

        public int dailyWinCount
        {
            get
            {
                return _dailyWinCount;
            }
            set
            {
                _dailyWinCount = value;
                _isDirty = true;
            }
        }

        public int ID
        {
            get
            {
                return _ID;
            }
            set
            {
                _ID = value;
                _isDirty = true;
            }
        }

        public int maxCount
        {
            get
            {
                return 30;
            }
            set
            {
                _maxCount = 30;
                _isDirty = true;
            }
        }

        public int rank
        {
            get
            {
                return _rank;
            }
            set
            {
                _rank = value;
                _isDirty = true;
            }
        }

        public int restCount
        {
            get
            {
                return _restCount;
            }
            set
            {
                _restCount = value;
                _isDirty = true;
            }
        }

        public int totalPrestige
        {
            get
            {
                return _totalPrestige;
            }
            set
            {
                _totalPrestige = value;
                _isDirty = true;
            }
        }

        public int UserID
        {
            get
            {
                return _userID;
            }
            set
            {
                _userID = value;
                _isDirty = true;
            }
        }

        public int weeklyGameCount
        {
            get
            {
                return _weeklyGameCount;
            }
            set
            {
                _weeklyGameCount = value;
                _isDirty = true;
            }
        }

        public int weeklyRanking
        {
            get
            {
                return _weeklyRanking;
            }
            set
            {
                _weeklyRanking = value;
                _isDirty = true;
            }
        }

        public int weeklyScore
        {
            get
            {
                return _weeklyScore;
            }
            set
            {
                _weeklyScore = value;
                _isDirty = true;
            }
        }

        public int leagueGrade
        {
            get
            {
                return _leagueGrade;
            }
            set
            {
                _leagueGrade = value;
                _isDirty = true;
            }
        }

        public int leagueItemsGet
        {
            get
            {
                return _leagueItemsGet;
            }
            set
            {
                _leagueItemsGet = value;
                _isDirty = true;
            }
        }

        public int WeeklyWinCount
        {
            get
            {
                return _weeklyWinCount;
            }
            set
            {
                _weeklyWinCount = value;
                _isDirty = true;
            }
        }
    }
}
