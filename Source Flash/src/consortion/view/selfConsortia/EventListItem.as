package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ConsortiaEventInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class EventListItem extends Sprite implements Disposeable
   {
       
      
      private var _backGroud:Bitmap;
      
      private var _eventType:ScaleFrameImage;
      
      private var _content:FilterFrameText;
      
      public function EventListItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._backGroud = ComponentFactory.Instance.creatBitmap("asset.eventItem.BG");
         this._eventType = ComponentFactory.Instance.creatComponentByStylename("eventItem.type");
         this._content = ComponentFactory.Instance.creatComponentByStylename("eventItem.content");
         addChild(this._backGroud);
         addChild(this._eventType);
         addChild(this._content);
      }
      
      public function set info(param1:ConsortiaEventInfo) : void
      {
         var _loc2_:String = param1.Date.toString().split(" ")[0];
         switch(param1.Type)
         {
            case 5:
               this._eventType.setFrame(1);
               if(param1.NickName.toLowerCase() == "gm")
               {
                  this._content.text = LanguageMgr.GetTranslation("ddt.consortia.event.contributeGM",_loc2_,param1.EventValue);
               }
               else
               {
                  this._content.text = LanguageMgr.GetTranslation("ddt.consortia.event.contribute",_loc2_,param1.NickName,param1.EventValue);
               }
               break;
            case 6:
               this._eventType.setFrame(2);
               this._content.text = LanguageMgr.GetTranslation("ddt.consortia.event.join",_loc2_,param1.ManagerName,param1.NickName);
               break;
            case 7:
               this._eventType.setFrame(3);
               this._content.text = LanguageMgr.GetTranslation("ddt.consortia.event.quite",_loc2_,param1.ManagerName,param1.NickName);
               break;
            case 8:
               this._eventType.setFrame(4);
               this._content.text = LanguageMgr.GetTranslation("ddt.consortia.event.quit",_loc2_,param1.NickName);
         }
         this._content.y = this._backGroud.height / 2 - this._content.textHeight / 2;
      }
      
      override public function get height() : Number
      {
         return this._backGroud.height;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._backGroud = null;
         this._eventType = null;
         this._content = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
