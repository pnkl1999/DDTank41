// Decompiled with JetBrains decompiler
// Type: Tank.Data.AppSettings
// Assembly: Tank.Data, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: C525111E-CE2F-4258-B464-2526A58BE4AE
// Assembly location: D:\DDT36\decompiled\bin\Tank.Data.dll

using SqlDataProvider.Data;
using System.Configuration;
using System.Web;

namespace Tank.Data
{
  public class AppSettings
  {
    public static string EmptySrc = AppSettings.Url_Authority() + "Backend/img/placeholders/avatars/avatar2.jpg";

    public static string DdtVersion => ConfigurationManager.AppSettings["DDT_VERSION"];

    public static string Url_Authority() => string.Format("{0}://{1}/", (object) HttpContext.Current.Request.Url.Scheme, (object) HttpContext.Current.Request.Url.Authority);

    public static string LocalRes => ConfigurationManager.AppSettings[nameof (LocalRes)];

    public static string LoginKey => ConfigurationManager.AppSettings[nameof (LoginKey)];

    public static string Bomb => ConfigurationManager.AppSettings[nameof (Bomb)];

    public static string Map => ConfigurationManager.AppSettings[nameof (Map)];

    public static string Resource => ConfigurationManager.AppSettings[nameof (Resource)];

    public static string SaveFilePatch => ConfigurationManager.AppSettings[nameof (SaveFilePatch)];

    public static int GetItemsType(int category)
    {
      switch (category)
      {
        case 1:
        case 5:
        case 7:
        case 17:
        case 27:
        case 31:
          return 2;
        case 2:
        case 3:
        case 4:
        case 6:
        case 8:
        case 9:
        case 13:
        case 14:
        case 15:
        case 16:
        case 28:
        case 29:
        case 40:
          return 1;
        default:
          return 0;
      }
    }

    public static string ResourceMount(int mountType)
    {
      string str1 = "";
      string str2;
      if (mountType >= 6 && mountType < 10)
        str2 = str1 + "image/mounts/horse/" + (object) mountType + "/1.png|" + "image/mounts/saddle/" + (object) mountType + "/1.png";
      else
        str2 = str1 + "image/mounts/horse/" + (object) mountType + "/1.png";
      return str2.ToLower();
    }

    public static string ResourceTitle(int pic) => "image/title/" + (object) pic + "/icon.png";

    public static string FurniturePath(string data, int property2) => ("image/house/" + AppSettings.Furniture(property2) + "/" + data + ".png|" + "image/house/" + AppSettings.Furniture(property2) + "/" + data + ".swf").ToLower();

    public static string Furniture(int category)
    {
      switch (category)
      {
        case 2:
          return "bookcase";
        case 3:
          return "carpet";
        case 4:
          return "desk";
        case 5:
          return "fence";
        case 6:
          return "floor";
        case 7:
          return "garden";
        case 8:
          return "platform";
        case 9:
          return "table";
        case 10:
          return "wall";
        case 11:
          return "wardrobe";
        case 12:
          return "window";
        case 13:
          return "brick";
        default:
          return "bed";
      }
    }

    public static string ResourcePetForms(string appearance, string resource) => ("image/pet/" + appearance + "/icon1.png|" + "image/pet/" + appearance + "/icon2.png|" + "image/game/living/" + resource + ".swf").ToLower();

    public static string ResourcePets(string Pic, string assetUrl)
    {
      Pic = Pic.ToLower();
      return ("image/pet/" + Pic + "/icon1.png|" + "image/pet/" + Pic + "/icon2.png|" + "image/pet/" + Pic + "/icon3.png|" + "image/gameasset/" + assetUrl + ".swf").ToLower();
    }

    public static string ResourceSkillPets(int type, string pic)
    {
      if (type == 1)
        return "image/petskill/" + pic.ToLower() + "/icon.png";
      return type == 3 ? "image/buff/" + pic.ToLower() + "/icon.png" : "image/skilleffect/" + pic.ToLower() + ".swf";
    }

    public static string ResourceMap(
      int type,
      int id,
      string deadPic,
      string forePic,
      string backMusic)
    {
      string str1 = "image/map/" + (object) id + "/samll_map.png|" + "image/map/" + (object) id + "/samll_map_s.jpg|" + "image/map/" + (object) id + "/show1.jpg|";
      switch (type)
      {
        case 1:
          string str2 = str1 + "image/map/" + (object) id + "/back.jpg|";
          if (!string.IsNullOrEmpty(deadPic))
            str2 = str2 + "image/map/" + (object) id + "/dead.png|";
          if (!string.IsNullOrEmpty(forePic))
            str2 = str2 + "image/map/" + (object) id + "/fore.png|";
          str1 = str2 + "sound/" + backMusic + ".flv|";
          break;
        case 2:
          str1 = str1 + "image/map/" + (object) id + "/show2.jpg|" + "image/map/" + (object) id + "/show3.jpg|" + "image/map/" + (object) id + "/show4.jpg|" + "image/map/" + (object) id + "/show5.jpg|";
          break;
      }
      return (str1 + "image/map/" + (object) id + "/icon.png").ToLower();
    }

    public static string ResourceWeapons(int ballId, string crater, string bombPartical)
    {
      string str = "";
      if (!string.IsNullOrEmpty(crater))
        str = str + "image/bomb/crater/" + crater + "/crater.png|" + "image/bomb/crater/" + crater + "/craterbrink.png|";
      return (str + "image/bomb/blastout/blastout" + (object) ballId + ".swf|" + "image/bomb/bullet/bullet" + bombPartical + ".swf").ToLower();
    }

    public static string BuildSrc2(ItemTemplateInfo info) => info != null ? AppSettings.BuildSrc(info.Pic, info.CategoryID, info.NeedSex, 2) : AppSettings.EmptySrc;

    public static string BuildSrc(ItemTemplateInfo info) => info != null ? AppSettings.BuildSrc(info.Pic, info.CategoryID, info.NeedSex, 0) : AppSettings.EmptySrc;

    public static string BuildSrc(int id, int pos)
    {
      ItemTemplateInfo itemTemplate = ItemTemplateMgr.FindItemTemplate(id);
      return itemTemplate != null ? AppSettings.BuildSrc(itemTemplate.Pic, itemTemplate.CategoryID, itemTemplate.NeedSex, pos) : AppSettings.EmptySrc;
    }

    public static string BuildSrc(string pic, int categoryId, int needSex, int pos)
    {
      string str1 = "";
      pic = pic.ToLower();
      string str2 = AppSettings.Resource;
      string str3 = needSex == 1 ? "m" : "f";
      switch (categoryId)
      {
        case 1:
          str1 = str1 + "image/equip/" + str3 + "/head/" + pic + "/icon_1.png|" + "image/equip/" + str3 + "/head/" + pic + "/1/game.png|" + "image/equip/" + str3 + "/head/" + pic + "/1/show.png|" + "image/equip/" + str3 + "/head/" + pic + "/2/game.png|" + "image/equip/" + str3 + "/head/" + pic + "/2/show.png";
          break;
        case 2:
          str1 = str1 + "image/equip/" + str3 + "/glass/" + pic + "/icon_1.png|" + "image/equip/" + str3 + "/glass/" + pic + "/1/game.png|" + "image/equip/" + str3 + "/glass/" + pic + "/1/show.png|" + "image/equip/" + str3 + "/glass/" + pic + "/2/game.png|" + "image/equip/" + str3 + "/glass/" + pic + "/2/show.png";
          break;
        case 3:
          str1 = str1 + "image/equip/" + str3 + "/hair/" + pic + "/icon_1.png|" + "image/equip/" + str3 + "/hair/" + pic + "/1/a/game.png|" + "image/equip/" + str3 + "/hair/" + pic + "/1/a/show.png|" + "image/equip/" + str3 + "/hair/" + pic + "/2/a/game.png|" + "image/equip/" + str3 + "/hair/" + pic + "/2/a/show.png|" + "image/equip/" + str3 + "/hair/" + pic + "/1/b/game.png|" + "image/equip/" + str3 + "/hair/" + pic + "/1/b/show.png|" + "image/equip/" + str3 + "/hair/" + pic + "/2/b/game.png|" + "image/equip/" + str3 + "/hair/" + pic + "/2/b/show.png|" + "image/virtual/" + str3 + "/hair/" + pic + "/1.png|" + "image/virtual/" + str3 + "/hair/" + pic + "/2.png";
          break;
        case 4:
          str1 = str1 + "image/equip/" + str3 + "/eff/" + pic + "/icon_1.png|" + "image/equip/" + str3 + "/eff/" + pic + "/1/game.png|" + "image/equip/" + str3 + "/eff/" + pic + "/1/show.png|" + "image/equip/" + str3 + "/eff/" + pic + "/2/game.png|" + "image/equip/" + str3 + "/eff/" + pic + "/2/show.png|" + "image/virtual/" + str3 + "/eff/" + pic + "/1.png|" + "image/virtual/" + str3 + "/eff/" + pic + "/2.png";
          break;
        case 5:
          str1 = str1 + "image/equip/" + str3 + "/cloth/" + pic + "/icon_1.png|" + "image/equip/" + str3 + "/cloth/" + pic + "/1/game.png|" + "image/equip/" + str3 + "/cloth/" + pic + "/1/show.png|" + "image/equip/" + str3 + "/cloth/" + pic + "/2/game.png|" + "image/equip/" + str3 + "/cloth/" + pic + "/2/show.png|" + "image/equip/" + str3 + "/cloth/" + pic + "/3/game.png|" + "image/equip/" + str3 + "/cloth/" + pic + "/3/show.png";
          break;
        case 6:
          str1 = str1 + "image/equip/" + str3 + "/face/" + pic + "/icon_1.png|" + "image/equip/" + str3 + "/face/" + pic + "/1/game.png|" + "image/equip/" + str3 + "/face/" + pic + "/1/show.png|" + "image/equip/" + str3 + "/face/" + pic + "/2/game.png|" + "image/equip/" + str3 + "/face/" + pic + "/2/show.png|" + "image/equip/" + str3 + "/face/" + pic + "/3/game.png|" + "image/equip/" + str3 + "/face/" + pic + "/3/show.png|" + "image/virtual/" + str3 + "/face/" + pic + "/1.png|" + "image/virtual/" + str3 + "/face/" + pic + "/2.png|" + "image/virtual/" + str3 + "/face/" + pic + "/3.png";
          break;
        case 7:
        case 27:
        case 64:
          str1 = str1 + "image/arm/" + pic + "/00.png|" + "image/arm/" + pic + "/1/icon.png|" + "image/arm/" + pic + "/1/0/show.png|" + "image/arm/" + pic + "/1/0/game.png|" + "image/arm/" + pic + "/1/1/game.png";
          break;
        case 8:
        case 28:
          str1 = str1 + "image/equip/armlet/" + pic + "/icon.png";
          break;
        case 9:
        case 29:
          str1 = str1 + "image/equip/ring/" + pic + "/icon.png";
          break;
        case 11:
        case 20:
        case 24:
        case 30:
        case 34:
        case 35:
        case 36:
        case 37:
        case 40:
        case 53:
        case 60:
        case 61:
        case 62:
        case 71:
        case 72:
          str1 = str1 + "image/unfrightprop/" + pic + "/icon.png";
          break;
        case 12:
          str1 = str1 + "image/task/" + pic + "/icon.png";
          break;
        case 13:
          str1 = str1 + "image/equip/" + str3 + "/suits/" + pic + "/icon_1.png|" + "image/equip/" + str3 + "/suits/" + pic + "/1/game.png|" + "image/equip/" + str3 + "/suits/" + pic + "/1/show.png|" + "image/equip/" + str3 + "/suits/" + pic + "/1/game1.png";
          break;
        case 14:
          str1 = str1 + "image/equip/necklace/" + pic + "/icon.png";
          break;
        case 15:
          str1 = str1 + "image/equip/wing/" + pic + "/icon.png|" + "image/equip/wing/" + pic + "/wings.fla|" + "image/equip/wing/" + pic + "/wings.swf";
          break;
        case 16:
          str1 = str1 + "image/specialprop/chatball/" + pic + "/icon.png";
          break;
        case 17:
        case 31:
          str1 = str1 + "image/equip/offhand/" + pic + "/icon.png";
          break;
        case 18:
        case 66:
          str1 = str1 + "image/cardbox/" + pic + "/icon.png";
          break;
        case 19:
          str1 = str1 + "image/equip/recover/" + pic + "/icon.png";
          break;
        case 25:
          str1 = str1 + "image/gift/" + pic + "/icon.png";
          break;
        case 26:
          str1 = str1 + "image/card/" + pic + "/icon.jpg";
          break;
        case 32:
          str1 = str1 + "image/farm/crops/" + pic + "/seed.png|" + "image/farm/crops/" + pic + "/crop0.png|" + "image/farm/crops/" + pic + "/crop1.png|" + "image/farm/crops/" + pic + "/crop2.png";
          break;
        case 33:
          str1 = str1 + "image/farm/fertilizer/" + pic + "/icon.png";
          break;
        case 50:
          str1 = str1 + "image/petequip/arm/" + pic + "/icon.png";
          break;
        case 51:
          str1 = str1 + "image/petequip/hat/" + pic + "/icon.png";
          break;
        case 52:
          str1 = str1 + "image/petequip/cloth/" + pic + "/icon.png";
          break;
        case 80:
          str1 = str1 + "image/prop/" + pic + "/icon.png";
          break;
        default:
          str2 = AppSettings.EmptySrc;
          break;
      }
      string[] strArray = str1.Split('|');
      if (pos < 0 || (uint) strArray.Length <= 0U)
        return string.IsNullOrEmpty(str1) ? str2 : str1;
      if (strArray.Length == 1)
        pos = 0;
      return str2 + (!strArray[pos].Contains("show") ? strArray[0] : strArray[pos]);
    }
  }
}
