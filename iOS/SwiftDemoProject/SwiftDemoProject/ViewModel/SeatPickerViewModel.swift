//
//  SeatPickerViewModel.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-05.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SeatPickerViewModel {
  let disposeBag = DisposeBag()
  
  private var ticket: Ticket!
  var numberOfSelectedSeat = BehaviorRelay<Int>(value: 0)
  var movieTitle = BehaviorRelay<String>(value: "")
  var movieLocation = BehaviorRelay<String>(value: "")
  var movieDateTime = BehaviorRelay<String>(value: "")
  var movieCover = BehaviorRelay<UIImage?>(value: nil)
  
  var selectedSeats: NSMutableSet = NSMutableSet()
  var seatNames: [Int: String] = [:]
  
  func updateTicket(ticket: Ticket) {
    self.ticket = ticket
    movieTitle.accept(ticket.movie.title)
    movieLocation.accept(ticket.location.name)
    movieDateTime.accept(ticket.getMovieDateTimeString())
    
    movieCover.accept(nil)
    ImageCache.shared().loadImage(url: ticket.movie.cover).subscribe(onNext: { [weak self] image in
      guard let self = self else { return }
      self.movieCover.accept(image)
    }).disposed(by: disposeBag)
  }
  
  func getTicketForNext() -> Ticket {
    ticket.seats.removeAll()
    for seat in selectedSeats {
      ticket.seats.append(seatNames[(seat as! UIButton).tag]!)
    }
    return ticket
  }
  
  func removeSelectedSeat(_ seat: Any) {
    selectedSeats.remove(seat)
    numberOfSelectedSeat.accept(selectedSeats.count)
  }
  
  func addSelectedSeat(_ seat: Any) {
    selectedSeats.add(seat)
    numberOfSelectedSeat.accept(selectedSeats.count)
  }
  
  func clearAllSelectedSeats() {
    selectedSeats.removeAllObjects()
    numberOfSelectedSeat.accept(0)
  }
}
