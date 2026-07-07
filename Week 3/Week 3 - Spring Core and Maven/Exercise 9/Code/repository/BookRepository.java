package com.library.LibrarymanagementSystem.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.library.LibrarymanagementSystem.model.Book;

public interface BookRepository extends JpaRepository<Book, Long> {
}
