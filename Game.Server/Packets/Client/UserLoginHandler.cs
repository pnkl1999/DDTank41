using Bussiness;
using Bussiness.Interface;
using Game.Base.Packets;
using Game.Server.Managers;
using SqlDataProvider.Data;
using System;
using System.Text;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.LOGIN, "User Login handler")]
    public class UserLoginHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            try
            {
                if (client.Player == null)
                {
                    int version = packet.ReadInt();
                    int clientType = packet.ReadInt();
                    if (clientType != 69)
                    {
                        byte[] tempKey = new byte[8];
                        byte[] src = packet.ReadBytes();
                        try
                        {
                            src = WorldMgr.RsaCryptor.Decrypt(src, fOAEP: false);
                        }
                        catch (Exception ex)
                        {
                            client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.RsaCryptorError"));
                            client.Disconnect();
                            GameServer.log.Error("RsaCryptor", ex);
                            return 0;
                        }
                        for (int i = 0; i < 8; i++)
                        {
                            tempKey[i] = src[i + 7];
                        }
                        client.setKey(tempKey);
                        string[] temp = Encoding.UTF8.GetString(src, 15, src.Length - 15).Split(',');
                        if (temp.Length == 2)
                        {
                            string user = temp[0];
                            string pass = temp[1];
                            if (!LoginMgr.ContainsUser(user))
                            {
                                bool isFirst = false;
                                BaseInterface inter = BaseInterface.CreateInterface();
                                PlayerInfo cha = inter.LoginGame(user, pass, GameServer.Instance.Configuration.AreaID, ref isFirst);
                                if (cha != null && cha.ID != 0)
                                {
                                    //if (cha.UserName == "khanhlam")
                                    //{
                                    if (cha.ID == -2)
                                    {
                                        client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.Forbid"));
                                        client.Disconnect();
                                        Console.WriteLine("{0} Forbid!", user);
                                        return 0;
                                    }
                                    if (!isFirst)
                                    {
                                        client.Player = new GamePlayer(cha.ID, user, client, cha);
                                        LoginMgr.Add(cha.ID, client);
                                        client.Server.LoginServer.SendAllowUserLogin(cha.ID);
                                        client.Version = version;
                                        Console.WriteLine("Tai Khoan {0} login Game ....", user); // Khai báo server
                                    }
                                    else
                                    {
                                        client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.Register"));
                                        client.Disconnect();
                                    }
                                    //}
                                    //else
                                    //{
                                    //    client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.LoginError"));
                                    //    client.Disconnect();
                                    //}

                                }
                                else
                                {
                                    Console.WriteLine("{0} Login with {1} OverTime....", user, pass);
                                    client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.OverTime"));
                                    client.Disconnect();
                                }
                            }
                            else
                            {
                                client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.LoginError"));
                                client.Disconnect();
                            }
                        }
                        else
                        {
                            client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.LoginError"));
                            client.Disconnect();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                client.Out.SendKitoff(LanguageMgr.GetTranslation("UserLoginHandler.ServerError"));
                client.Disconnect();
                GameServer.log.Error(LanguageMgr.GetTranslation("UserLoginHandler.ServerError"), ex);
            }
            return 1;
        }
    }
}
