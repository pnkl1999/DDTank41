using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdNormalKingSecond : ABrain
    {
        private int m_attackTurn = 0;

        private int npcID = 3106;

        private SimpleBoss friendBoss;

        private int BloodRecover = 2000;

        private List<PhysicalObj> phyStarList = new List<PhysicalObj>();

        private static string[] AllAttackChat = new string[]{
            "Kiếm thần!!! Kiếm thần!!",
            "Hãy đỡ tuyệt chiêu kiếm thần!!",
            "Kiếm thần!! Trợ giúp!!",
            "Kiếm thần đây. Hãy đỡ!!!!"
        };

        private static string[] CallChat = new string[]{
            "Vệ binh! <br/> bảo vệ! ! ",
            "Dũng sĩ bộ lạc đâu thể hiện đi!",
            "Đệ tử của ta đâu mau ra đây!!!",
            "Lính đâu ra giết bọn chúng."
        };

        private static string[] ShootCallChat = new string[]{
           "Chạy à? Chạy nữa đi!!!",
           "Một phát chết 3 con gián.",
           "Trẻ trâu mà láo à?",
           "Lũ gà!!! Chết này."

        };

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            if (friendBoss == null || friendBoss.IsLiving == false)
            {
                List<Living> listLiving = Game.FindAllTurnBossLiving();
                foreach (Living lv in listLiving)
                {
                    if (lv != Body)
                    {
                        friendBoss = (lv as SimpleBoss);
                        return;
                    }
                }
            }
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > Body.X - 300 && player.X < Body.X + 300)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(Body.X - 300, Body.X + 300);
                return;
            }

            // kiem tra xem co hoi sinh dc ko
            if (friendBoss != null && friendBoss.IsLiving == false)
            {
                Body.PlayMovie("castA", 800, 0);
                Body.Say("Anh trai ơi đừng đầu hàng.<br/>Em sẽ giúp anh hồi sinh!!!", 0, 1000);
                ((PVEGame)Game).SendObjectFocus(friendBoss, 1, 3000, 1000);
                Body.CallFuction(new LivingCallBack(ReviveFriendBoss), 5000);
                return;
            }

            if (friendBoss != null && friendBoss.Blood <= (friendBoss.NpcInfo.Blood / 10))
            {
                Body.PlayMovie("castA", 800, 0);
                Body.Say("Các ngươi làm sao đủ khả năng đánh bại anh ta!!!", 0, 1000);
                ((PVEGame)Game).SendObjectFocus(friendBoss, 1, 3500, 5000);
                Body.CallFuction(new LivingCallBack(RecoverFriendBlood), 4000);
                return;
            }

            JumpBeat();
        }

        public void RecoverFriendBlood()
        {
            friendBoss.AddBlood(BloodRecover);
        }

        public void ReviveFriendBoss()
        {
            SimpleBoss newBoss = null;
            LivingConfig configLiving = ((PVEGame)Game).BaseConfig();
            configLiving.ReduceBloodStart = 2;

            Game.RemoveLiving(friendBoss.Id);

            newBoss = ((PVEGame)Game).CreateBoss(friendBoss.NpcInfo.ID, friendBoss.X, friendBoss.Y, friendBoss.Direction, 1, "raise", configLiving);
            newBoss.SetRelateDemagemRect(newBoss.NpcInfo.X, newBoss.NpcInfo.Y, newBoss.NpcInfo.Width, newBoss.NpcInfo.Height);
            newBoss.Say("Ta đã hồi sinh!!! Các ngươi phải chết.", 0, 3000);
            friendBoss = newBoss;
        }

        private void JumpBeat()
        {
            if (Body.Y >= 310 && Body.Y <= 420)
            {
                // đang ở vị trí 1 => nhảy xuống vt 2
                Body.FallFromTo(Body.X, 477, "", 1000, 0, 25, new LivingCallBack(GoInBeat));
            }
            else if (Body.Y >= 450 && Body.Y <= 540)
            {
                // đang ở vị trí 2 => nhảy xuống vt3
                Body.PlayMovie("walk", 100, 1000);
                Body.FallFromTo(Body.X, 623, "", 1000, 0, 25, new LivingCallBack(GoInBeat));
            }
            else if (Body.Y >= 580 && Body.Y <= 668)
            {
                // đang ở vị trí 3 => nhảy lên vt1
                Body.JumpTo(Body.X, 361, "walk", 1000, 1, 20, new LivingCallBack(GoInBeat));
            }

        }

        private void GoInBeat()
        {
            // hành dộng tiếp theo
            switch (m_attackTurn)
            {
                case 0:
                    ShootBeat();
                    break;
                case 1:
                    CreateAllAttack();
                    break;
                case 2:
                    CallbBoss();
                    m_attackTurn = 0;
                    break;
            }
            m_attackTurn++;
        }

        private void ShootBeat()
        {
            Player target = Game.FindRandomPlayer();
            Body.PlayMovie("stand", 0, 0);
            Body.CurrentDamagePlus = 1.8f;

            int index = Game.Random.Next(0, ShootCallChat.Length);
            Body.Say(ShootCallChat[index], 0, 1000);
            
            if (target != null)
            {
                if (Body.ShootPoint(target.X, target.Y, 54, 1000, 10000, 3, 2f, 2300))
                {
                    Body.PlayMovie("beatA", 1500, 0);
                }
            }
        }

        private void CallbBoss()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 0, 1000);

            Body.PlayMovie("castA", 1000, 0);
            Body.CallFuction(new LivingCallBack(CreateChild), 4000);
        }

        public void CreateChild()
        {
            ((SimpleBoss)Body).CreateChild(npcID, 1369, 242, 0, 1, -1);
        }

        private void CreateAllAttack()
        {
            Body.CurrentDamagePlus = 1.5f;
            int index = Game.Random.Next(0, AllAttackChat.Length);
            Body.Say(AllAttackChat[index], 0, 1000);

            Body.PlayMovie("castA", 1000, 0);
            //((PVEGame)Game).SendGameFocus(823, 625, 1, 4000, 0);

            Player pScanel = Game.FindRandomPlayer();
            ((PVEGame)Game).SendObjectFocus(pScanel, 2, 3000, 1000);

            Body.CallFuction(new LivingCallBack(CreateStarMovie), 4000);
            
        }

        public void CreateStarMovie()
        {
            foreach (Player target in Game.GetAllPlayers())
            {
                if (target.IsLiving)
                {
                    PhysicalObj phy = ((PVEGame)Game).Createlayer(target.X, target.Y, "", "game.crazytank.assetmap.Dici", "", 1, 0);
                    phyStarList.Add(phy);
                }
            }
            
            Body.RangeAttacking(-10000, 10000, "cry", 700, null);
            Body.CallFuction(new LivingCallBack(RemoveMovie), 1500);
        }

        public void RemoveMovie()
        {
            foreach(PhysicalObj phy in phyStarList)
            {
                Game.RemovePhysicalObj(phy, true);
            }
            phyStarList = new List<PhysicalObj>();
        }

        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 100f;
            Body.PlayMovie("call", 1000, 0);
            Body.RangeAttacking(fx, tx, "cry", 4000, null);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
