<?php

namespace Models;

use Illuminate\Database\Eloquent\Model;

class LogMomo extends Model
{
    protected $table='Log_Momo';
    
    protected $primaryKey='id';
    
    public $timestamps = false;
    
    protected $guarded = ['id'];
}