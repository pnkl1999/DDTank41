using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Game.Server.RobotWaiting
{
    public class Robot
    {
        public string Name { get; set; } = "Robot";

        public int Level { get; set; } = 20;

        public int GP { get; set; } = 12462;

        public bool Sex { get; set; }

        public int UserType { get; set; } = 1;

        public int VIPLevel { get; set; }

        public byte typeVIP { get; set; } = 2;

        public byte State { get; set; } = 1;

        public byte masterID { get; set; } = 0;

        public byte apprenticeshipState { get; set; } = 1;

        public string VIPExpireDay { get; set; } = new DateTime(2018, 1, 1).ToString();

        public List<EquipBot> Equips { get; set; } = new List<EquipBot>
            {
                new EquipBot()
            };
    }
}
