describe('Dashboard', () => {
  beforeEach(() => {
    cy.login('test@example.com', 'password123')
    cy.visit('/app')
  })

  it('should display welcome message', () => {
    cy.contains('Bonjour').should('be.visible')
    cy.contains('Bienvenue sur votre tableau de bord').should('be.visible')
  })

  it('should show statistics', () => {
    cy.get('.grid').first().within(() => {
      cy.get('div').should('have.length.gt', 2)
      cy.contains('Équipements disponibles').should('be.visible')
      cy.contains('Réservations').should('be.visible')
    })
  })

  it('should display available equipment section', () => {
    cy.contains('Équipements disponibles').should('be.visible')
    cy.get('a').contains('Voir tous').should('be.visible')
    cy.get('.grid').last().within(() => {
      cy.get('div').should('have.length.gt', 0)
    })
  })

  it('should display recent reservations', () => {
    cy.contains('Dernières réservations').should('be.visible')
    cy.get('a').contains('Voir toutes').should('be.visible')
    cy.get('ul').within(() => {
      cy.get('li').should('have.length.gte', 0)
    })
  })

  it('should navigate to full equipment list', () => {
    cy.get('a').contains('Voir tous').click()
    cy.url().should('include', '/app/equipment')
  })

  it('should navigate to full reservations list', () => {
    cy.get('a').contains('Voir toutes').click()
    cy.url().should('include', '/app/reservations')
  })
})