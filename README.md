# RaceDay Event Management System

## System Description

RaceDay is an event management system designed to manage race events, organisers, participants, event categories, enrolments, and race results.

The system allows organisers to create and manage race events and categories, while participants can register for events and categories. The database stores user information, event details, enrolments, and race results in a structured relational database.

## System Roles

### 1. Organiser

The Organiser manages race events and their categories. The Organiser can create and update event information, manage event categories, and monitor participant enrolments.

### 2. Participant

The Participant can view available race events and categories, enrol in events, provide their required information, and view their enrolment and race results.

## Database

The RaceDay database was created using Microsoft SQL Server and contains the following entities:

* Users
* Organisers
* Participants
* Events
* Categories
* Enrolments
* Results

The database uses primary keys and foreign keys to maintain relationships and data integrity between the entities.

## API Endpoint Plan

The API endpoint plan documents the RESTful API endpoints required for authentication, user profiles, events, categories, event enrolments, and results.

The endpoint plan includes HTTP methods, routes, descriptions, required roles, request bodies, and expected responses.

## ERD

The Entity Relationship Diagram (ERD) shows the entities, attributes, primary keys, foreign keys, and relationships used in the RaceDay database.

The ERD is available in the `/docs` folder.

## Documentation

The `/docs` folder contains:

* RaceDay ERD
* API Endpoint Plan
* SQL Database Script


