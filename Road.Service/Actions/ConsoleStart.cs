using Bussiness;
using Bussiness.Managers;
using Game.Base;
using Game.Logic;
using Game.Server;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.Rooms;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Threading;

namespace Game.Service.actions
{
    public class ConsoleStart : IAction
    {
        private delegate int ConsoleCtrlDelegate(ConsoleEvent ctrlType);

        private enum ConsoleEvent
        {
            Ctrl_C,
            Ctrl_Break,
            Close,
            Logoff,
            Shutdown
        }

        private GameServerConfig config;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Timer _timer;

        private static int _count;

        private static ConsoleCtrlDelegate handler;

        public string Name => "--start";

        public string Syntax => "--start [-config=./config/serverconfig.xml]";

        public string Description => "Starts the DOL server in console mode";

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern IntPtr GetStdHandle(int nStdHandle);

        [DllImport("kernel32.dll")]
        private static extern bool ReadConsoleW(IntPtr hConsoleInput, [Out] byte[] lpBuffer, uint nNumberOfCharsToRead, out uint lpNumberOfCharsRead, IntPtr lpReserved);

        public static IntPtr GetWin32InputHandle()
        {
            return GetStdHandle(-10);
        }

        public void OnAction(Hashtable parameters)
        {
            Console.Title = "Road Service | DDTank 3.0";
            GameServer.CreateInstance(config = new GameServerConfig());
            GameServer.Instance.Start();
            GameServer.KeepRunning = true;
            FusionCombined.ListCombinedFusion();
            Console.WriteLine("Server started!");
            ConsoleClient client = new ConsoleClient();
            while (GameServer.KeepRunning)
            {
                try
                {
                    handler = ConsoleCtrHandler;
                    SetConsoleCtrlHandler(handler, add: true);
                    Console.Write("> ");
                    string line = Console.ReadLine();
                    switch (line.Split(' ')[0])
                    {
                        case "exit":
                            GameServer.KeepRunning = false;
                            continue;
                        case "cp":
                            {
                                GameClient[] clients = GameServer.Instance.GetAllClients();
                                int clientCount = ((clients != null) ? clients.Length : 0);
                                GamePlayer[] players = WorldMgr.GetAllPlayers();
                                int playerCount = ((players != null) ? players.Length : 0);
                                List<BaseRoom> allUsingRoom = RoomMgr.GetAllUsingRoom();
                                int roomCount = 0;
                                int gameCount = 0;
                                foreach (BaseRoom r in allUsingRoom)
                                {
                                    if (!r.IsEmpty)
                                    {
                                        roomCount++;
                                        if (r.IsPlaying)
                                        {
                                            gameCount++;
                                        }
                                    }
                                }
                                double memoryCount = GC.GetTotalMemory(forceFullCollection: false);
                                Console.WriteLine($"Total Clients/Players:{clientCount}/{playerCount}");
                                Console.WriteLine($"Total Rooms/Games:{roomCount}/{gameCount}");
                                Console.WriteLine($"Total Momey Used:{memoryCount / 1024.0 / 1024.0} MB");
                                continue;
                            }
                        case "shutdown":
                            _count = 6;
                            _timer = new Timer(ShutDownCallBack, null, 0, 60000);
                            continue;
                        case "clear":
                            Console.Clear();
                            continue;
                        case "ball&reload":
                            if (BallMgr.ReLoad())
                            {
                                Console.WriteLine("Ball info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("Ball info is Error!");
                            }
                            continue;
                        case "drop&reload":
                            if (DropMgr.ReLoad())
                            {
                                Console.WriteLine("Drop info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("Drop info is Error!");
                            }
                            continue;
                        case "map&reload":
                            if (MapMgr.ReLoadMap())
                            {
                                Console.WriteLine("Map info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("Map info is Error!");
                            }
                            continue;
                        case "mapserver&reload":
                            if (MapMgr.ReLoadMapServer())
                            {
                                Console.WriteLine("mapserver info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("mapserver info is Error!");
                            }
                            continue;
                        case "prop&reload":
                            if (PropItemMgr.Reload())
                            {
                                Console.WriteLine("prop info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("prop info is Error!");
                            }
                            continue;
                        case "item&reload":
                            if (ItemMgr.ReLoad())
                            {
                                Console.WriteLine("item info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("item info is Error!");
                            }
                            continue;
                        case "shop&reload":
                            if (ShopMgr.ReLoad())
                            {
                                Console.WriteLine("shop info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("shop info is Error!");
                            }
                            continue;
                        case "petskill":
                            if (PetMgr.ReLoad())
                            {
                                Console.WriteLine("PetMgr Reload Success!");
                            }
                            else
                            {
                                Console.WriteLine("PetMgr Reload Error!");
                            }
                            continue;
                        case "mission":
                            if (MissionInfoMgr.Reload())
                            {
                                Console.WriteLine("Mission Reload Sucess!");
                            }
                            else
                            {
                                Console.WriteLine("Mission Reload Error!");
                            }
                            continue;
                        case "pve":
                            if (PveInfoMgr.ReLoad())
                            {
                                Console.WriteLine("PVE Reload Sucess!");
                            }
                            else
                            {
                                Console.WriteLine("PVE Reload Error!");
                            }
                            continue;
                        case "itembox":
                            if (ItemBoxMgr.ReLoad())
                            {
                                Console.WriteLine("ItemBox Reload Success!");
                            }
                            else
                            {
                                Console.WriteLine("ItemBox Reload Error!");
                            }
                            continue;
                        case "eventaward":
                            if (EventAwardMgr.ReLoad())
                            {
                                Console.WriteLine("EventAward Reload Success!");
                            }
                            else
                            {
                                Console.WriteLine("EventAward Reload Error!");
                            }
                            continue;
                        case "goldequip":
                            if (GoldEquipMgr.ReLoad())
                            {
                                Console.WriteLine("GoldEquip Reload Success!");
                            }
                            else
                            {
                                Console.WriteLine("GoldEquip Reload Error!");
                            }
                            continue;
                        case "strengthen":
                            if (StrengthenMgr.ReLoad())
                            {
                                Console.WriteLine("Strengthen Reload Success!");
                            }
                            else
                            {
                                Console.WriteLine("Strengthen Reload Error!");
                            }
                            continue;
                        case "quest&reload":
                            if (QuestMgr.ReLoad())
                            {
                                Console.WriteLine("quest info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("quest info is Error!");
                            }
                            continue;
                        case "npc&reload":
                            if (NPCInfoMgr.ReLoad())
                            {
                                Console.WriteLine("npc info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("npc info is Error!");
                            }
                            continue;
                        case "fusion&reload":
                            if (FusionMgr.ReLoad())
                            {
                                FusionCombined.ListCombinedFusion();
                                Console.WriteLine("fusion info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("fusion info is Error!");
                            }
                            continue;
                        case "consortia&reload":
                            if (ConsortiaMgr.ReLoad())
                            {
                                Console.WriteLine("consortiaMgr info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("consortiaMgr info is Error!");
                            }
                            continue;
                        case "rate&reload":
                            if (RateMgr.ReLoad())
                            {
                                Console.WriteLine("Rate Rate is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("Rate Rate is Error!");
                            }
                            continue;
                        case "fight&reload":
                            if (FightRateMgr.ReLoad())
                            {
                                Console.WriteLine("FightRateMgr is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("FightRateMgr is Error!");
                            }
                            continue;
                        case "dailyaward&reload":
                            if (AwardMgr.ReLoad())
                            {
                                Console.WriteLine("dailyaward is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("dailyaward is Error!");
                            }
                            continue;
                        case "language&reload":
                            if (LanguageMgr.Reload(""))
                            {
                                Console.WriteLine("language is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("language is Error!");
                            }
                            continue;
                        case "strengthen&reload":
                            if (StrengthenMgr.ReLoad())
                            {
                                Console.WriteLine("Strengthen Info is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("Strengthen Info is Error!");
                            }
                            continue;
                        case "itembox&reload":
                            if (ItemBoxMgr.ReLoad())
                            {
                                Console.WriteLine("ItemBoxMgr is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("ItemBoxMgr is Error!");
                            }
                            continue;
                        case "pet&reload":
                            if (PetMgr.Init())
                            {
                                Console.WriteLine("PetMgr is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("PetMgr is Error!");
                            }
                            continue;
                        case "nickname":
                            Console.WriteLine("Please enter the nickname");
                            Console.WriteLine(WorldMgr.GetPlayerStringByPlayerNickName(Console.ReadLine()));
                            continue;
                        case "cfg&reload":
                            ConfigurationManager.RefreshSection("appSettings");
                            Console.WriteLine("Configuration file is Reload!");
                            continue;
                        case "gp&reload":
                            GameProperties.Refresh();
                            Console.WriteLine("Game Properties is Reload!");
                            continue;
                        case "eventlive&reload":
                            if (EventLiveMgr.ReLoad())
                            {
                                Console.WriteLine("EventLiveMgr is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("EventLiveMgr is Error!");
                            }
                            continue;
                        case "commands&reload":
                            if (CommandsMgr.Init())
                            {
                                Console.WriteLine("CommandsMgr is Reload!");
                            }
                            else
                            {
                                Console.WriteLine("CommandsMgr is Error!");
                            }
                            continue;
                        case "senditem":
                            {
                                GamePlayer player = null;
                                Console.WriteLine("Please enter the type, 0 = UserID, 1 = UserName, 2 = NickName:");
                                switch (int.Parse(Console.ReadLine()))
                                {
                                    case 0:
                                        Console.WriteLine("Please enter the UserID:");
                                        player = WorldMgr.GetPlayerById(int.Parse(Console.ReadLine()));
                                        break;
                                    case 1:
                                        Console.WriteLine("Please enter the UserName:");
                                        player = WorldMgr.GetClientByPlayerUserName(Console.ReadLine());
                                        break;
                                    case 2:
                                        Console.WriteLine("Please enter the NickName:");
                                        player = WorldMgr.GetClientByPlayerNickName(Console.ReadLine());
                                        break;
                                    default:
                                        Console.WriteLine("Type invalid, in the next time, please enter 0, 1 or 2");
                                        goto end_IL_004e;
                                }
                                if (player == null)
                                {
                                    Console.WriteLine("The player couldn't be found online in the server");
                                    continue;
                                }
                                Console.WriteLine("Please enter the TemplateID");
                                ItemTemplateInfo itemTemplateInfo = ItemMgr.FindItemTemplate(int.Parse(Console.ReadLine()));
                                ItemInfo item = ItemInfo.CreateFromTemplate(itemTemplateInfo, itemTemplateInfo.MaxCount, 104);
                                if (itemTemplateInfo == null)
                                {
                                    Console.WriteLine("The item not exists in the server");
                                }
                                else if (player.SendItemToMail(item, "Recompensas do Sistema:                                           " + item.Template.Name, "Administador do Sistema", eMailType.Default))
                                {
                                    Console.ForegroundColor = ConsoleColor.Green;
                                    Console.WriteLine("Item " + item.Template.Name + " sent successfully to NickName " + player.PlayerCharacter.NickName);
                                    Console.ResetColor();
                                }
                                continue;
                            }
                        case "resetquest":
                            {
                                //GamePlayer player2 = null;
                                //Console.WriteLine("Please enter the type, 0 = UserID, 1 = UserName, 2 = NickName:");
                                //switch (int.Parse(Console.ReadLine()))
                                //{
                                //    case 0:
                                //        Console.WriteLine("Please enter the UserID:");
                                //        player2 = WorldMgr.GetPlayerById(int.Parse(Console.ReadLine()));
                                //        break;
                                //    case 1:
                                //        Console.WriteLine("Please enter the UserName:");
                                //        player2 = WorldMgr.GetClientByPlayerUserName(Console.ReadLine());
                                //        break;
                                //    case 2:
                                //        Console.WriteLine("Please enter the NickName:");
                                //        player2 = WorldMgr.GetClientByPlayerNickName(Console.ReadLine());
                                //        break;
                                //    default:
                                //        Console.WriteLine("Type invalid, in the next time, please enter 0, 1 or 2");
                                //        goto end_IL_004e;
                                //}
                                //if (player2 == null)
                                //{
                                //    Console.WriteLine("The player couldn't be found online in the server");
                                //}
                                //else if (player2.QuestInventory.Restart())
                                //{
                                //    Console.ForegroundColor = ConsoleColor.Green;
                                //    Console.WriteLine("Quests Restarted successfully on " + player2.PlayerCharacter.NickName);
                                //    Console.ResetColor();
                                //    player2.QuestInventory.LoadFromDatabase(player2.PlayerCharacter.ID);
                                //}
                                continue;
                            }
                        case "chargetouser":
                            {
                                GamePlayer player3 = null;
                                Console.WriteLine("Please enter the type, 0 = UserID, 1 = UserName, 2 = NickName:");
                                switch (int.Parse(Console.ReadLine()))
                                {
                                    case 0:
                                        Console.WriteLine("Please enter the UserID:");
                                        player3 = WorldMgr.GetPlayerById(int.Parse(Console.ReadLine()));
                                        break;
                                    case 1:
                                        Console.WriteLine("Please enter the UserName:");
                                        player3 = WorldMgr.GetClientByPlayerUserName(Console.ReadLine());
                                        break;
                                    case 2:
                                        Console.WriteLine("Please enter the NickName:");
                                        player3 = WorldMgr.GetClientByPlayerNickName(Console.ReadLine());
                                        break;
                                    default:
                                        Console.WriteLine("Type invalid, in the next time, please enter 0, 1 or 2");
                                        goto end_IL_004e;
                                }
                                if (player3 == null)
                                {
                                    Console.WriteLine("The player couldn't be found online in the server");
                                    continue;
                                }
                                player3.ChargeToUser();
                                Console.ForegroundColor = ConsoleColor.Green;
                                Console.WriteLine("Quests Restarted successfully on " + player3.PlayerCharacter.NickName);
                                Console.ResetColor();
                                continue;
                            }
                        case "reloadall":
                            {
                                ConfigurationManager.RefreshSection("appSettings");
                                Console.WriteLine("Configuration file is Reload!");
                                GameProperties.Refresh();
                                Console.WriteLine("Game Properties is Reload!");
                                if (EventLiveMgr.ReLoad())
                                {
                                    Console.WriteLine("EventLiveMgr is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("EventLiveMgr is Error!");
                                }
                                if (NewTitleMgr.ReLoad())
                                {
                                    Console.WriteLine("NewTitleMgr is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("NewTitleMgr is Error!");
                                }
                                if (PetMgr.Init())
                                {
                                    Console.WriteLine("PetMgr is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("PetMgr is Error!");
                                }
                                if (ItemBoxMgr.ReLoad())
                                {
                                    Console.WriteLine("ItemBoxMgr is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("ItemBoxMgr is Error!");
                                }
                                
                                if (LanguageMgr.Reload(""))
                                {
                                    Console.WriteLine("language is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("language is Error!");
                                }
                                
                                if (FusionMgr.ReLoad())
                                {
                                    FusionCombined.ListCombinedFusion();
                                    Console.WriteLine("fusion info is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("fusion info is Error!");
                                }

                                if (NPCInfoMgr.ReLoad())
                                {
                                    Console.WriteLine("npc info is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("npc info is Error!");
                                }

                                if (DropMgr.ReLoad())
                                {
                                    Console.WriteLine("Drop info is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("Drop info is Error!");
                                }

                                if (ItemMgr.ReLoad())
                                {
                                    Console.WriteLine("item info is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("item info is Error!");
                                }

                                if (ShopMgr.ReLoad())
                                {
                                    Console.WriteLine("shop info is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("shop info is Error!");
                                }

                                if (MissionInfoMgr.Reload())
                                {
                                    Console.WriteLine("Mission Reload Sucess!");
                                }
                                else
                                {
                                    Console.WriteLine("Mission Reload Error!");
                                }

                                if (ItemBoxMgr.ReLoad())
                                {
                                    Console.WriteLine("ItemBox Reload Success!");
                                }
                                else
                                {
                                    Console.WriteLine("ItemBox Reload Error!");
                                }
                                if (EventAwardMgr.ReLoad())
                                {
                                    Console.WriteLine("EventAward Reload Success!");
                                }
                                else
                                {
                                    Console.WriteLine("EventAward Reload Error!");
                                }
                                
                                if (QuestMgr.ReLoad())
                                {
                                    Console.WriteLine("quest info is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("quest info is Error!");
                                }

                                if (ClothGroupTemplateInfoMgr.ReLoad())
                                {
                                    Console.WriteLine("ClothGroupTemplateInfoMgr is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("ClothGroupTemplateInfoMgr is Error!");
                                }

                                if (ClothPropertyTemplateInfoMgr.ReLoad())
                                {
                                    Console.WriteLine("ClothPropertyTemplateInfoMgr is Reload!");
                                }
                                else
                                {
                                    Console.WriteLine("ClothPropertyTemplateInfoMgr is Error!");
                                }
                                continue;
                            }
                    }
                    if (line.Length <= 0)
                    {
                        continue;
                    }
                    if (line[0] == '/')
                    {
                        line = line.Remove(0, 1);
                        line = line.Insert(0, "&");
                    }
                    try
                    {
                        if (!CommandMgr.HandleCommandNoPlvl(client, line))
                        {
                            Console.WriteLine("Unknown command: " + line);
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.ToString());
                    }
                    end_IL_004e:;
                }
                catch (Exception value)
                {
                    Console.WriteLine(value);
                }
            }
            if (GameServer.Instance != null)
            {
                GameServer.Instance.Stop();
            }
            LogManager.Shutdown();
        }

        private static void ShutDownCallBack(object state)
        {
            _count--;
            Console.WriteLine($"Server will shutdown after {_count} mins!");
            GameClient[] allClients = GameServer.Instance.GetAllClients();
            GameClient[] array = allClients;
            foreach (GameClient c in array)
            {
                if (c.Out != null)
                {
                    c.Out.SendMessage(eMessageType.GM_NOTICE, string.Format("{0}{1}{2}", LanguageMgr.GetTranslation("Game.Service.actions.ShutDown1"), _count, LanguageMgr.GetTranslation("Game.Service.actions.ShutDown2")));
                }
            }
            if (_count == 0)
            {
                _timer.Dispose();
                _timer = null;
                GameServer.Instance.Stop();
                Console.WriteLine("Server has stopped!");
                GameServer.KeepRunning = false;
                Environment.Exit(0);
                return;
            }
        }

        [DllImport("kernel32.dll", CallingConvention = CallingConvention.StdCall)]
        private static extern int SetConsoleCtrlHandler(ConsoleCtrlDelegate HandlerRoutine, bool add);

        private static int ConsoleCtrHandler(ConsoleEvent e)
        {
            SetConsoleCtrlHandler(handler, add: false);
            if (GameServer.Instance != null)
            {
                GameServer.Instance.Stop();
            }
            return 0;
        }
    }
}
