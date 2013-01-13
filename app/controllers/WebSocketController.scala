package controllers

import play.api.mvc.{WebSocket, Controller}
import play.api.libs.iteratee.{PushEnumerator, Enumerator, Iteratee}


object WebSocketController extends Controller {

  def sample[A](out: PushEnumerator[String]) =
  { message:A =>  {
      println("Received: "+message)
      out.push("echo: "+message)
  }:Unit
  }

  def commandSocket = WebSocket.using[String] { request =>
    val out = Enumerator.imperative[String]()

    val in = Iteratee.foreach[String](sample[String](out)).mapDone { _ =>
      println("Disconnected")
    }

      (in, out)

  }

}
