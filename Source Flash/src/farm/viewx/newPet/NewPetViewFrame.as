package farm.viewx.newPet
{
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.analyze.PetconfigAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import pet.date.PetInfo;
   
   public class NewPetViewFrame extends Frame
   {
       
      
      private var _newPetItem:NewPetShowItem;
      
      private var _PetSkillPnl:NewPetSkillPanel;
      
      private var _yeziBmp:Bitmap;
      
      private var _huawen1:Bitmap;
      
      private var _huawen2:Bitmap;
      
      private var _huawen3:Bitmap;
      
      private var _huawen4:Bitmap;
      
      private var _titleBmp:Bitmap;
      
      private var _petSkillTxt:FilterFrameText;
      
      private var _petComeTxt:FilterFrameText;
      
      private var _newPetDesc:FilterFrameText;
      
      private var _newPetSkillBg:ScaleBitmapImage;
      
      private var _newPetLvTxt:FilterFrameText;
      
      public function NewPetViewFrame()
      {
         super();
         this.initEvent();
         this.initView();
      }
      
      private function initView() : void
      {
         this._titleBmp = ComponentFactory.Instance.creatBitmap("assets.farm.newPetCome");
         addToContent(this._titleBmp);
         this._huawen1 = ComponentFactory.Instance.creatBitmap("assets.farm.newPetHuawen");
         this._huawen1.x = 20;
         this._huawen1.y = 15;
         this._huawen2 = ComponentFactory.Instance.creatBitmap("assets.farm.newPetHuawen");
         this._huawen2.rotation = 90;
         this._huawen2.x = 203;
         this._huawen2.y = 15;
         this._huawen3 = ComponentFactory.Instance.creatBitmap("assets.farm.newPetHuawen");
         this._huawen3.rotation = 180;
         this._huawen3.x = 203;
         this._huawen3.y = 135;
         this._huawen4 = ComponentFactory.Instance.creatBitmap("assets.farm.newPetHuawen");
         this._huawen4.rotation = -90;
         this._huawen4.x = 20;
         this._huawen4.y = 135;
         addToContent(this._huawen1);
         addToContent(this._huawen2);
         addToContent(this._huawen3);
         addToContent(this._huawen4);
         this._newPetSkillBg = ComponentFactory.Instance.creatComponentByStylename("farm.newPetSkill.bg");
         addToContent(this._newPetSkillBg);
         this._PetSkillPnl = ComponentFactory.Instance.creat("farm.petSkillPnl");
         this._PetSkillPnl.scrollVisble = false;
         addToContent(this._PetSkillPnl);
         this._petSkillTxt = ComponentFactory.Instance.creatComponentByStylename("farm.pet.newPetSkillTxt");
         this._petSkillTxt.text = LanguageMgr.GetTranslation("ddt.farm.newPet.SkillTxt");
         addToContent(this._petSkillTxt);
         this._petComeTxt = ComponentFactory.Instance.creatComponentByStylename("farm.pet.newPetComeTxt");
         this._petComeTxt.text = LanguageMgr.GetTranslation("ddt.farm.newPet.Come");
         addToContent(this._petComeTxt);
         this._newPetDesc = ComponentFactory.Instance.creatComponentByStylename("farm.pet.newPetDescTxt");
         this._newPetDesc.text = PetconfigAnalyzer.PetCofnig.NewPetDescribe;
         addToContent(this._newPetDesc);
         this._newPetLvTxt = ComponentFactory.Instance.creatComponentByStylename("farm.pet.newPetLvTxt");
         this._newPetLvTxt.text = LanguageMgr.GetTranslation("ddt.farm.newPet.LvTxt");
         addToContent(this._newPetLvTxt);
      }
      
      public function set petInfo(param1:PetInfo) : void
      {
         if(!this._newPetItem)
         {
            this._newPetItem = new NewPetShowItem(param1);
            this._newPetItem.x = 69;
            this._newPetItem.y = 25;
            addToContent(this._newPetItem);
         }
         this._PetSkillPnl.itemInfo = param1.skills;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
               TweenMax.to(this,0.2,{
                  "x":250,
                  "onComplete":this.OnTweenComplete
               });
         }
      }
      
      private function OnTweenComplete() : void
      {
         dispatchEvent(new Event("newPetFrameClose"));
         this.dispose();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(this._huawen1)
         {
            ObjectUtils.disposeObject(this._huawen1);
         }
         this._huawen1 = null;
         if(this._huawen2)
         {
            ObjectUtils.disposeObject(this._huawen2);
         }
         this._huawen2 = null;
         if(this._huawen3)
         {
            ObjectUtils.disposeObject(this._huawen3);
         }
         this._huawen3 = null;
         if(this._huawen4)
         {
            ObjectUtils.disposeObject(this._huawen4);
         }
         this._huawen4 = null;
         if(this._PetSkillPnl)
         {
            ObjectUtils.disposeObject(this._PetSkillPnl);
         }
         this._PetSkillPnl = null;
         if(this._newPetItem)
         {
            ObjectUtils.disposeObject(this._newPetItem);
         }
         this._newPetItem = null;
         super.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
