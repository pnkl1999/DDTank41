package auctionHouse.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class VerticalMenu extends Sprite implements Disposeable
   {
      
      public static const MENU_CLICKED:String = "menuClicked";
      
      public static const MENU_REFRESH:String = "menuRefresh";
       
      
      private var tabWidth:Number;
      
      private var l1Width:Number;
      
      private var l2Width:Number;
      
      private var subMenus:Array;
      
      private var rootMenu:Array;
      
      public var currentItem:IMenuItem;
      
      public var isseach:Boolean;
      
      private var _height:int;
      
      public function VerticalMenu(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.tabWidth = param1;
         this.l1Width = param2;
         this.l2Width = param3;
         this.rootMenu = [];
         this.subMenus = [];
      }
      
      public function addItemAt(param1:IMenuItem, param2:int = -1) : void
      {
         var _loc3_:uint = 0;
         if(param2 == -1)
         {
            this.rootMenu.push(param1);
            param1.addEventListener(MouseEvent.CLICK,this.rootMenuClickHandler);
         }
         else
         {
            if(!this.subMenus[param2])
            {
               _loc3_ = 0;
               while(_loc3_ <= param2)
               {
                  if(!this.subMenus[_loc3_])
                  {
                     this.subMenus[_loc3_] = [];
                  }
                  _loc3_++;
               }
            }
            param1.x = this.tabWidth;
            param1.addEventListener(MouseEvent.CLICK,this.subMenuClickHandler);
            this.subMenus[param2].push(param1);
         }
         addChild(param1 as DisplayObject);
         this.closeAll();
      }
      
      public function closeAll() : void
      {
         var _loc3_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < this.rootMenu.length)
         {
            this.rootMenu[_loc1_].y = _loc1_ * this.l1Width;
            this.rootMenu[_loc1_].isOpen = false;
            this.rootMenu[_loc1_].enable = true;
            _loc1_++;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.subMenus.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.subMenus[_loc2_].length)
            {
               this.subMenus[_loc2_][_loc3_].visible = false;
               this.subMenus[_loc2_][_loc3_].y = 0;
               _loc3_++;
            }
            _loc2_++;
         }
         this._height = this.rootMenu.length * this.l1Width;
      }
      
      public function get $height() : Number
      {
         return this._height;
      }
      
      protected function rootMenuClickHandler(param1:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         SoundManager.instance.play("008");
         if(this.currentItem != null)
         {
            this.currentItem.enable = true;
         }
         this.currentItem = param1.currentTarget as IMenuItem;
         var _loc2_:int = this.rootMenu.indexOf(this.currentItem);
         if(this.currentItem.isOpen)
         {
            this.closeAll();
            this.currentItem.enable = false;
            _loc3_ = 0;
            while(_loc3_ < this.subMenus.length)
            {
               _loc4_ = 0;
               while(_loc4_ < this.subMenus[_loc3_].length)
               {
                  this.subMenus[_loc3_][_loc4_].enable = true;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         else
         {
            this.closeAll();
            this.openItemByIndex(_loc2_);
            this.isseach = false;
            this.currentItem.enable = false;
         }
         dispatchEvent(new Event(MENU_REFRESH));
      }
      
      private function closeItems() : void
      {
      }
      
      private function openItemByIndex(param1:uint) : void
      {
         var _loc4_:uint = 0;
         if(!this.subMenus[param1])
         {
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.rootMenu.length)
         {
            if(_loc2_ <= param1)
            {
               this.rootMenu[_loc2_].y = _loc2_ * this.l1Width;
            }
            else
            {
               this.rootMenu[_loc2_].y = _loc2_ * this.l1Width + this.subMenus[param1].length * this.l2Width;
            }
            _loc2_++;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < this.subMenus.length)
         {
            _loc4_ = 0;
            while(_loc4_ < this.subMenus[_loc3_].length)
            {
               if(_loc3_ == param1)
               {
                  this.subMenus[_loc3_][_loc4_].visible = true;
                  this.subMenus[_loc3_][_loc4_].enable = true;
                  this.subMenus[_loc3_][_loc4_].y = (param1 + 1) * this.l1Width + _loc4_ * this.l2Width;
               }
               else
               {
                  this.subMenus[_loc3_][_loc4_].visible = false;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         this._height = this.rootMenu.length * this.l1Width + this.subMenus[param1].length * this.l2Width;
         this.rootMenu[param1].isOpen = true;
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.rootMenu)
         {
            _loc1_ = 0;
            while(_loc1_ < this.rootMenu.length)
            {
               this.rootMenu[_loc1_].removeEventListener(MouseEvent.CLICK,this.rootMenuClickHandler);
               ObjectUtils.disposeObject(this.rootMenu[_loc1_]);
               this.rootMenu[_loc1_] = null;
               _loc1_++;
            }
         }
         this.rootMenu = null;
         if(this.subMenus)
         {
            _loc2_ = 0;
            while(_loc2_ < this.subMenus.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this.subMenus[_loc2_].length)
               {
                  this.subMenus[_loc2_][_loc3_].removeEventListener(MouseEvent.CLICK,this.subMenuClickHandler);
                  ObjectUtils.disposeObject(this.subMenus[_loc2_][_loc3_]);
                  this.subMenus[_loc2_][_loc3_] = null;
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         this.subMenus = null;
         this.currentItem = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      protected function subMenuClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.isseach = true;
         if(this.currentItem)
         {
            this.currentItem.enable = true;
         }
         this.currentItem = param1.currentTarget as IMenuItem;
         this.currentItem.enable = false;
         dispatchEvent(new Event(MENU_CLICKED));
      }
   }
}
