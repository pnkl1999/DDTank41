using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.RobotWaiting
{
    public class EquipBot
    {
        //public int ID { get; set; } = 7001;

        //public int Strength { get; set; } = 0;

        //public int Compose { get; set; } = 0;

        //private int _iD;
        private int _strength;
        private int _compose;

        //public int ID { get => _iD; set => _iD = value; }
        public List<int> itemID = new List<int> { 7008, 13146, 15059 };
        public int Strength { get => _strength; set => _strength = value; }
        public int Compose { get => _compose; set => _compose = value; }

        public EquipBot()
        {
            Random random = new Random();
            _strength = random.Next(0, 8);
            _compose = 0;
        }
    }
}
