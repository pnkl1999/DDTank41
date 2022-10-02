using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;

namespace Game.Server.GameServerScript.AI.Game
{
    public class Labyrinth1 : APVEGameControl
    {
        public override void OnCreated()
        {
            string id = "40001,40002,40003,40004,40005,40006,40007,40008,40009,40010";
            id += ",40011,40012,40013,40014,40015,40016,40017,40018,40019,40020";
            id += ",40021,40022,40023,40024,40025,40026,40027,40028,40029,40030";
            id += ",40031,40032,40033,40034,40035,40036,40037,40038,40039,40040";
            Game.SetupMissions(id);
            Game.TotalMissionCount = id.Split(',').Length;
        }

        public override void OnPrepated()
        {
            //Game.SessionId = 0;
        }

        public override int CalculateScoreGrade(int score)
        {
            if(score > 800)
            {
                return 3;
            }
            else if(score > 725)
            {
                return 2;
            }
            else if(score > 650)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public override void OnGameOverAllSession()
        {
        }
    }
}
