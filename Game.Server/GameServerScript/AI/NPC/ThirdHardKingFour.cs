using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;
using System.Drawing;
using Game.Logic.Phy.Maths;
using SqlDataProvider.Data;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdHardKingFour : ABrain
    {
        private bool isBornEffect = false;

        private int m_bloodReduce = 700;

        private int maxShootPlayer = 4;

        private int npcEnemyId = 3218;

        private SimpleNpc npcEnemy = null;

        private int m_turn = 0;

        private List<PhysicalObj> phyFireObjs = new List<PhysicalObj>();

        private List<Point> pointCreatePhy = new List<Point>();

        private int coldDownAttackNPC = 0;

        public List<SimpleNpc> orchins = new List<SimpleNpc>();

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[]{
             "Tiếng gầm của hổ ...！",

             "Cảm nhận sự đau đớn của cổ họng！ "
        };

        private static string[] ShootChat = new string[]{
             "Lửa địa ngục...",

             "Tam nhị chân hỏa !",

             "Đốt ngươi chết luôn"
        };

        private static string[] CallChat = new string[]{
            "Xem đây，<br/>Cây đậu đáng ghét!!",
            "Biến khỏi đây không ??"
        };

        private static string[] EnemyNPCChat = new string[]{
            "Thật nguy hiểm!!",
            "Ta không chịu thua ngươi đâu!",
            "Không bao giờ khuất phục."
        };

        private static string[] KillAttackChat = new string[]{
            "Dám đến gần ta, chết đi...",
            "Nhìn mặt mà ngu vãi!!!",
            "Ta dẫm cho nát bét!!!!"
        };

        private static string[] SealChat = new string[]{
            "Chạy đường nào đây?",
            "Tìm chỗ mà núp đi nhé!!"
        };

        private static string[] KillPlayerChat = new string[]{
            "Lửa bất diệt cháy bừng lên đi!"
        };
        #endregion


        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            if (coldDownAttackNPC > 0)
                coldDownAttackNPC--;
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            if (!isBornEffect)
            {
                BornEffect();
                isBornEffect = true;
            }
            else
            {
                bool result = false;
                Body.Direction = Game.FindlivingbyDir(Body);
                foreach (Player player in Game.GetAllFightPlayers())
                {
                    if (player.IsLiving && player.X > Body.X - 200 && player.X < Body.X + 200)
                    {
                        result = true;
                    }
                }

                if (result)
                {
                    KillAttack(Body.X - 200, Body.X + 200);
                    return;
                }

                // check can attack npc enemy
                if (coldDownAttackNPC <= 0)
                {
                    coldDownAttackNPC = 5;
                    AttackEnemyNPC();
                    return;
                }


                switch (m_turn)
                {
                    case 0:
                    case 1:
                        HalfAttack();
                        break;

                    case 2:
                        PersonAttack();
                        break;

                    case 3:
                        GlobalMoveAttack();
                        break;

                    case 4:
                        PersonAttack();
                        m_turn = 0;
                        break;
                }
                m_turn++;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void HalfAttack()
        {
            Body.CurrentDamagePlus = 1.5f;
            int index = Game.Random.Next(0, AllAttackChat.Length);
            Body.Say(AllAttackChat[index], 1, 500);
            Body.PlayMovie("beatB", 1000, 3000);
            Body.RangeAttacking(Body.X - 10000, Body.Y + 10000, "cry", 3000, null);
        }

        private void PersonAttack()
        {
            Body.CurrentDamagePlus = 1.2f;
            int index = Game.Random.Next(0, ShootChat.Length);
            Body.Say(ShootChat[index], 1, 500);

            Player p = Game.FindRandomPlayer();

            if (p != null)
            {
                Body.ChangeDirection(Body.FindDirection(p), 100);
                int delayTime = 2000;
                for (int i = 0; i < maxShootPlayer; i++)
                {
                    if (Body.ShootPoint(p.X, p.Y, 53, 1000, 10000, 3, 2.3f, delayTime))
                    {
                        Body.PlayMovie("aim", delayTime - 1000, 0);
                        Body.PlayMovie("beatA", delayTime - 500, 0);
                    }
                    delayTime += 2000;
                }
            }
        }

        private void GlobalMoveAttack()
        {
            Body.CurrentDamagePlus = 2f;
            int index = Game.Random.Next(0, SealChat.Length);
            ((SimpleBoss)Body).Say(SealChat[index], 1, 500);

            Body.PlayMovie("beatC", 0, 1000);

            Body.CallFuction(new LivingCallBack(MoveAllPlayer), 2200);


        }

        private void MoveAllPlayer()
        {
            List<Player> players = Game.GetAllLivingPlayers();

            foreach (Player player in players)
            {
                int dis = Game.Random.Next(200, 1300);

                pointCreatePhy.Add(new Point(dis, 500));

                player.BoltMove(dis, 500, 50);
            }

            CreateFlameEffect();
            Body.RangeAttacking(Body.X - 10000, Body.Y + 10000, "cry", 100, null);
        }

        private void AttackEnemyNPC()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            ((SimpleBoss)Body).Say(CallChat[index], 1, 500);

            Body.ChangeDirection(Body.FindDirection(npcEnemy), 100);

            if (Body.ShootPoint(npcEnemy.X, npcEnemy.Y, 53, 1000, 10000, 1, 2.0f, 2550))
            {
                Body.PlayMovie("aim", 1300, 0);
            }

            Body.PlayMovie("beatA", 2000, 0);

            npcEnemy.PlayMovie("die", 2000, 0);

            if (npcEnemy.X <= 700)
            {
                // ben trai => sang ben phai
                npcEnemy.JumpTo(1225, 563, "born", 5000, 0, 100, null, 1);
                npcEnemy.ChangeDirection(-1, 6000);
                Body.ChangeDirection(1, 6000);
            }
            else
            {
                npcEnemy.JumpTo(468, 555, "born", 5000, 0, 100, null, 1);
                npcEnemy.ChangeDirection(1, 6000);
                Body.ChangeDirection(-1, 6000);
            }
            ((PVEGame)Game).SendObjectFocus(npcEnemy, 1, 5000, 0);
            index = Game.Random.Next(0, EnemyNPCChat.Length);
            npcEnemy.Say(EnemyNPCChat[index], 1, 6500, 2000);

        }

        private void BornEffect()
        {
            Body.Say("Thể xác ốm yếu này, đưa ta mượn tạm xem!", 0, 4000);

            Body.MoveTo(761, 583, "walk", 5000, 3);

            Body.Say("Lửa địa ngục hãy cháy lên!!!", 0, 6000);

            Body.PlayMovie("beatC", 6000, 0);

            Player[] allPlayers = Game.GetAllPlayers();

            foreach (Player p in allPlayers)
            {
                if (p != null && p.IsLiving)
                {
                    p.AddEffect(new ContinueReduceBloodEffect(200, m_bloodReduce, null), 7800);
                }
            }

            //Body.CallFuction(new LivingCallBack(Remove), 9000);

            Body.CallFuction(new LivingCallBack(BornNPCEnemy), 8300);
        }

        private void BornNPCEnemy()
        {
            LivingConfig config = ((PVEGame)Game).BaseConfig();

            config.CanTakeDamage = false;

            npcEnemy = ((PVEGame)Game).CreateNpc(npcEnemyId, 468, 555, 1, 1, config);

            npcEnemy.Say("Lửa vĩnh cửu thật khó bị dập tắt. Hãy theo sát tôi, tôi sẽ làm giảm sức mạnh của chúng", 0, 1500, 3000);

            //((PVEGame)Game).PveGameDelay = 0;

            coldDownAttackNPC = 5;
        }

        public void CreateFlameEffect()
        {
            foreach (Point p in pointCreatePhy)
            {
                PhysicalObj phy = ((PVEGame)Game).Createlayer(p.X, p.Y, "", "game.assetmap.Flame", "", 1, 1);
                phyFireObjs.Add(phy);
            }
            pointCreatePhy = new List<Point>();

            Body.CallFuction(new LivingCallBack(Remove), 2000);
        }

        public void Remove()
        {
            foreach (PhysicalObj phy in phyFireObjs)
            {
                if (phy != null)
                    Game.RemovePhysicalObj(phy, true);
            }
            phyFireObjs = new List<PhysicalObj>();
        }

        public void KillAttack(int fx, int mx)
        {
            Body.CurrentDamagePlus = 25;
            int index = Game.Random.Next(0, KillAttackChat.Length);
            ((SimpleBoss)Body).Say(KillAttackChat[index], 1, 500);
            Body.PlayMovie("beatC", 2500, 0);
            Body.RangeAttacking(fx, mx, "cry", 3300, null);
        }

    }
}
